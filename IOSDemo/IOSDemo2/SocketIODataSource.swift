//
//  SocketIODataSource.swift
//  IOSDemo2
//
//  Created by Chi Yang on 11/5/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SocketIO

// TODO: add delegate class
/**
SocketIOManager

- variable: sharedInstance
*/
open class SocketIODataSource: NSObject, AsyncInitStep {
	// https://github.com/socketio/socket.io-client-swift/issues/382
	
	/**SocketIOClient passes the jwt token as params*/
	var socket: SocketIOClient!
	
	public override init() {
		super.init()
	}
	
	func subscribeToRoom(_ room: String, completionHandler: @escaping (([JSQMessage]) -> Void)) {
		self.socket.emit("subscribe", ["room": room])
		self.socket.on("update room messages") {dataArray, ack in
			if let messages = dataArray.first as? [AnyObject] {
				if (messages.count != 0) {
					var jsqMsgs: [JSQMessage] = []
					for m in messages {
						if let msg = m as? [String: AnyObject] {
							if let jsqMsg = self.parseJSQMessage(msg) {
								jsqMsgs.append(jsqMsg)
							}
						}
					}
					completionHandler(jsqMsgs)
					self.socket.emit("room messages updated", ["room": room])
				}
			}
		}
	}
	
	func sendMessage(_ room: String, message:JSQMessage) {
		self.socket.emit("send message", [
			"room": room,
			"message":[
				"text" : message.text,
				"date" : Int(message.date.timeIntervalSince1970),
				"displayName" : message.senderDisplayName,
				"senderId" : message.senderId
			]])
	}
	
	/**func establishConnection()*/
	open func establishConnection() {
		self.socket.on("connection") {data, ack in
			print("socket connected")
		}
		self.socket.connect()
	}
	
	open func closeConnection() {
		self.socket.disconnect()
	}
	
	func getChatMessage(_ completionHandler: @escaping(_ message: JSQMessage?) -> Void) {
		self.socket.on("room private post") { (dataArray, socketAck) -> Void in
			if let temp = dataArray.first as? [String: AnyObject] {
				if let msg = temp["message"] as? [String: AnyObject] {
					//public convenience init!(senderId: String!, displayName: String!, text: String!)
					if let jsqMsg = self.parseJSQMessage(msg) {
						completionHandler(jsqMsg)
					}
				}
			}
			completionHandler(nil)
		}
	}
	
	func parseJSQMessage(_ msg: [String: AnyObject]) -> JSQMessage? {
		if let senderId = msg["senderId"] as? String {
			var text = ""
			if let temp = msg["text"] as? String {
				text = temp
			}
			var date = Date()
			if let temp = msg["date"] as? Int {
				date = Date(timeIntervalSince1970: Double(temp))
			}
			var displayName = ""
			if let temp = msg["displayName"] as? String {
				displayName = temp
			}
			
			let jsqMsg = JSQMessage(
				senderId: senderId,
				senderDisplayName: displayName,
				date: date,
				text: text)
			return jsqMsg
		}
		return nil
	}
	
	func asyncInit(_ completionHandler: ((AnyObject) -> Void)) {
		self.socket = SocketIOClient(socketURL: URL(string: SEVERURL)!, config: SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.connectParams([LoginInfo.token:TOKEN])))
		self.establishConnection()
		completionHandler(NSNull)
	}
}
