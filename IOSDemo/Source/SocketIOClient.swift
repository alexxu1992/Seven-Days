//
//  SocketIOClient.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 11/23/14.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public final class SocketIOClient : NSObject, SocketEngineClient, SocketParsable {
    public let socketURL: URL

    public fileprivate(set) var engine: SocketEngineSpec?
    public fileprivate(set) var status = SocketIOClientStatus.notConnected {
        didSet {
            switch status {
            case .connected:
                reconnecting = false
                currentReconnectAttempt = 0
            default:
                break
            }
        }
    }

    public var forceNew = false
    public var nsp = "/"
    public var config: SocketIOClientConfiguration
    public var reconnects = true
    public var reconnectWait = 10

    fileprivate let ackQueue = DispatchQueue(label: "com.socketio.ackQueue", attributes: [])
    fileprivate let emitQueue = DispatchQueue(label: "com.socketio.emitQueue", attributes: [])
    fileprivate let logType = "SocketIOClient"
    fileprivate let parseQueue = DispatchQueue(label: "com.socketio.parseQueue", attributes: [])

    fileprivate var anyHandler: ((SocketAnyEvent) -> Void)?
    fileprivate var currentReconnectAttempt = 0
    fileprivate var handlers = [SocketEventHandler]()
    fileprivate var ackHandlers = SocketAckManager()
    fileprivate var reconnecting = false

    fileprivate(set) var currentAck = -1
    fileprivate(set) var handleQueue = DispatchQueue.main
    fileprivate(set) var reconnectAttempts = -1

    var waitingPackets = [SocketPacket]()
    
    public var sid: String? {
        return nsp + "#" + (engine?.sid ?? "")
    }
    
    /// Type safe way to create a new SocketIOClient. config can be omitted
    public init(socketURL: URL, config: SocketIOClientConfiguration = []) {
        self.config = config
        self.socketURL = socketURL
        
        if socketURL.absoluteString?.hasPrefix("https://") ?? false {
            self.config.insert(.secure(true))
        }
        
        for option in config {
            switch option {
            case let .reconnects(reconnects):
                self.reconnects = reconnects
            case let .reconnectAttempts(attempts):
                reconnectAttempts = attempts
            case let .reconnectWait(wait):
                reconnectWait = abs(wait)
            case let .nsp(nsp):
                self.nsp = nsp
            case let .log(log):
                DefaultSocketLogger.Logger.log = log
            case let .logger(logger):
                DefaultSocketLogger.Logger = logger
            case let .handleQueue(queue):
                handleQueue = queue
            case let .forceNew(force):
                forceNew = force
            default:
                continue
            }
        }
        
        self.config.insert(.path("/socket.io/"), replacing: false)
        
        super.init()
    }
    
    /// Not so type safe way to create a SocketIOClient, meant for Objective-C compatiblity.
    /// If using Swift it's recommended to use `init(socketURL: NSURL, options: Set<SocketIOClientOption>)`
    public convenience init(socketURL: URL, config: NSDictionary?) {
        self.init(socketURL: socketURL, config: config?.toSocketConfiguration() ?? [])
    }

    deinit {
        DefaultSocketLogger.Logger.log("Client is being released", type: logType)
        engine?.disconnect("Client Deinit")
    }

    fileprivate func addEngine() -> SocketEngineSpec {
        DefaultSocketLogger.Logger.log("Adding engine", type: logType)

        engine = SocketEngine(client: self, url: socketURL, config: config)

        return engine!
    }

    /// Connect to the server.
    public func connect() {
        connect(timeoutAfter: 0, withTimeoutHandler: nil)
    }

    /// Connect to the server. If we aren't connected after timeoutAfter, call handler
    public func connect(timeoutAfter: Int, withTimeoutHandler handler: (() -> Void)?) {
        assert(timeoutAfter >= 0, "Invalid timeout: \(timeoutAfter)")

        guard status != .connected else {
            DefaultSocketLogger.Logger.log("Tried connecting on an already connected socket", type: logType)
            return
        }

        status = .connecting

        if engine == nil || forceNew {
            addEngine().connect()
        } else {
            engine?.connect()
        }
        
        guard timeoutAfter != 0 else { return }

        let time = DispatchTime.now() + Double(Int64(timeoutAfter) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)

        handleQueue.asyncAfter(deadline: time) {[weak self] in
            guard let this = self , this.status != .connected && this.status != .disconnected else { return }
            
            this.status = .disconnected
            this.engine?.disconnect("Connect timeout")
            
            handler?()
        }
    }

    fileprivate func createOnAck(_ items: [AnyObject]) -> OnAckCallback {
        currentAck += 1

        return {[weak self, ack = currentAck] timeout, callback in
            guard let this = self else { return }
            
            this.ackQueue.sync {
                this.ackHandlers.addAck(ack, callback: callback)
            }
            
            
            this._emit(items, ack: ack)
            
            if timeout != 0 {
                let time = DispatchTime.now() + Double(Int64(timeout * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                
                this.ackQueue.asyncAfter(deadline: time) {
                    this.ackHandlers.timeoutAck(ack, onQueue: this.handleQueue)
                }
            }
        }
    }

    func didConnect() {
        DefaultSocketLogger.Logger.log("Socket connected", type: logType)
        status = .connected

        // Don't handle as internal because something crazy could happen where
        // we disconnect before it's handled
        handleEvent("connect", data: [], isInternalMessage: false)
    }

    func didDisconnect(_ reason: String) {
        guard status != .disconnected else { return }

        DefaultSocketLogger.Logger.log("Disconnected: %@", type: logType, args: reason)

        reconnecting = false
        status = .disconnected

        // Make sure the engine is actually dead.
        engine?.disconnect(reason)
        handleEvent("disconnect", data: [reason], isInternalMessage: true)
    }

    /// Disconnects the socket.
    public func disconnect() {
        DefaultSocketLogger.Logger.log("Closing socket", type: logType)

        didDisconnect("Disconnect")
    }

    /// Send a message to the server
    public func emit(_ event: String, _ items: AnyObject...) {
        emit(event, withItems: items)
    }

    /// Same as emit, but meant for Objective-C
    public func emit(_ event: String, withItems items: [AnyObject]) {
        guard status == .connected else {
            handleEvent("error", data: ["Tried emitting \(event) when not connected"], isInternalMessage: true)
            return
        }
        
        _emit([event] + items)
    }

    /// Sends a message to the server, requesting an ack. Use the onAck method of SocketAckHandler to add
    /// an ack.
    public func emitWithAck(_ event: String, _ items: AnyObject...) -> OnAckCallback {
        return emitWithAck(event, withItems: items)
    }

    /// Same as emitWithAck, but for Objective-C
    public func emitWithAck(_ event: String, withItems items: [AnyObject]) -> OnAckCallback {
        return createOnAck([event] + items)
    }

    fileprivate func _emit(_ data: [AnyObject], ack: Int? = nil) {
        emitQueue.async {
            guard self.status == .connected else {
                self.handleEvent("error", data: ["Tried emitting when not connected"], isInternalMessage: true)
                return
            }
            
            let packet = SocketPacket.packetFromEmit(data, id: ack ?? -1, nsp: self.nsp, ack: false)
            let str = packet.packetString
            
            DefaultSocketLogger.Logger.log("Emitting: %@", type: self.logType, args: str)
            
            self.engine?.send(str, withData: packet.binary)
        }
    }

    // If the server wants to know that the client received data
    func emitAck(_ ack: Int, withItems items: [AnyObject]) {
        emitQueue.async {
            if self.status == .connected {
                let packet = SocketPacket.packetFromEmit(items, id: ack ?? -1, nsp: self.nsp, ack: true)
                let str = packet.packetString

                DefaultSocketLogger.Logger.log("Emitting Ack: %@", type: self.logType, args: str)

                self.engine?.send(str, withData: packet.binary)
            }
        }
    }

    public func engineDidClose(_ reason: String) {
        waitingPackets.removeAll()
        
        if status != .disconnected {
            status = .notConnected
        }

        if status == .disconnected || !reconnects {
            didDisconnect(reason)
        } else if !reconnecting {
            reconnecting = true
            tryReconnectWithReason(reason)
        }
    }

    /// error
    public func engineDidError(_ reason: String) {
        DefaultSocketLogger.Logger.error("%@", type: logType, args: reason)

        handleEvent("error", data: [reason], isInternalMessage: true)
    }
    
    public func engineDidOpen(_ reason: String) {
        DefaultSocketLogger.Logger.log(reason, type: "SocketEngineClient")
    }

    // Called when the socket gets an ack for something it sent
    func handleAck(_ ack: Int, data: [AnyObject]) {
        guard status == .connected else { return }

        DefaultSocketLogger.Logger.log("Handling ack: %@ with data: %@", type: logType, args: ack, data ?? "")

        ackQueue.async {
            self.ackHandlers.executeAck(ack, items: data, onQueue: self.handleQueue)
        }
    }

    /// Causes an event to be handled. Only use if you know what you're doing.
    public func handleEvent(_ event: String, data: [AnyObject], isInternalMessage: Bool, withAck ack: Int = -1) {
        guard status == .connected || isInternalMessage else { return }

        DefaultSocketLogger.Logger.log("Handling event: %@ with data: %@", type: logType, args: event, data ?? "")

        handleQueue.async {
            self.anyHandler?(SocketAnyEvent(event: event, items: data))

            for handler in self.handlers where handler.event == event {
                handler.executeCallback(data, withAck: ack, withSocket: self)
            }
        }
    }

    /// Leaves nsp and goes back to /
    public func leaveNamespace() {
        if nsp != "/" {
            engine?.send("1\(nsp)", withData: [])
            nsp = "/"
        }
    }

    /// Joins namespace
    public func joinNamespace(_ namespace: String) {
        nsp = namespace

        if nsp != "/" {
            DefaultSocketLogger.Logger.log("Joining namespace", type: logType)
            engine?.send("0\(nsp)", withData: [])
        }
    }

    /// Removes handler(s) based on name
    public func off(_ event: String) {
        DefaultSocketLogger.Logger.log("Removing handler for event: %@", type: logType, args: event)

        handlers = handlers.filter({ $0.event != event })
    }

    /// Removes a handler with the specified UUID gotten from an `on` or `once`
    public func off(id: UUID) {
        DefaultSocketLogger.Logger.log("Removing handler with id: %@", type: logType, args: id)

        handlers = handlers.filter({ $0.id != id })
    }

    /// Adds a handler for an event.
    /// Returns: A unique id for the handler
    public func on(_ event: String, callback: NormalCallback) -> UUID {
        DefaultSocketLogger.Logger.log("Adding handler for event: %@", type: logType, args: event)

        let handler = SocketEventHandler(event: event, id: UUID(), callback: callback)
        handlers.append(handler)

        return handler.id
    }

    /// Adds a single-use handler for an event.
    /// Returns: A unique id for the handler
    public func once(_ event: String, callback: NormalCallback) -> UUID {
        DefaultSocketLogger.Logger.log("Adding once handler for event: %@", type: logType, args: event)

        let id = UUID()

        let handler = SocketEventHandler(event: event, id: id) {[weak self] data, ack in
            guard let this = self else { return }
            this.off(id: id)
            callback(data, ack)
        }

        handlers.append(handler)

        return handler.id
    }

    /// Adds a handler that will be called on every event.
    public func onAny(_ handler: (SocketAnyEvent) -> Void) {
        anyHandler = handler
    }

    public func parseEngineMessage(_ msg: String) {
        DefaultSocketLogger.Logger.log("Should parse message: %@", type: "SocketIOClient", args: msg)

        parseQueue.async {
            self.parseSocketMessage(msg)
        }
    }

    public func parseEngineBinaryData(_ data: Data) {
        parseQueue.async {
            self.parseBinaryData(data)
        }
    }

    /// Tries to reconnect to the server.
    public func reconnect() {
        guard !reconnecting else { return }
        
        engine?.disconnect("manual reconnect")
    }

    /// Removes all handlers.
    /// Can be used after disconnecting to break any potential remaining retain cycles.
    public func removeAllHandlers() {
        handlers.removeAll(keepingCapacity: false)
    }

    fileprivate func tryReconnectWithReason(_ reason: String) {
        guard reconnecting else { return }

        DefaultSocketLogger.Logger.log("Starting reconnect", type: logType)
        handleEvent("reconnect", data: [reason], isInternalMessage: true)
        
        _tryReconnect()
    }

    fileprivate func _tryReconnect() {
        guard reconnecting else { return }

        if reconnectAttempts != -1 && currentReconnectAttempt + 1 > reconnectAttempts || !reconnects {
            return didDisconnect("Reconnect Failed")
        }

        DefaultSocketLogger.Logger.log("Trying to reconnect", type: logType)
        handleEvent("reconnectAttempt", data: [reconnectAttempts - currentReconnectAttempt],
            isInternalMessage: true)

        currentReconnectAttempt += 1
        connect()
        
        let time = DispatchTime.now() + Double(Int64(UInt64(reconnectWait) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: _tryReconnect)
    }
}

// Test extensions
extension SocketIOClient {
    var testHandlers: [SocketEventHandler] {
        return handlers
    }

    func setTestable() {
        status = .connected
    }

    func setTestEngine(_ engine: SocketEngineSpec?) {
        self.engine = engine
    }

    func emitTest(_ event: String, _ data: AnyObject...) {
        _emit([event] + data)
    }
}
