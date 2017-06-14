//
//  MessageViewController.swift
//  IOSDemo2
//
//  Created by Chi Yang on 11/5/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import JSQMessagesViewController
/**
MessageViewController: JSQMessagesViewController is used in
EngageMainViewController and LastingMainViewController

room a.k.a roomid is defined by
"selfuserid" + "otheruserid" or "otheruserid" + "selfuserid"
the smaller one comes first

We store locally with Realm

*/

class MessageViewController: JSQMessagesViewController, MessageDataSourceDelegate {
	// TODO: add these uicolors (need design from UX) to the uicolor extension class
	let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.lightGray)
	let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
	/** Navigation Bar Height, also move the chat view down as inset*/
	let navBarHeight:CGFloat = 60.0
	
	/** room id that socket listens to*/
	// TODO: only for testing purpose should be replaced later
	var room:String = "room"
	/**message can contain media types, check JSQMessage for more details
	Need to discuss about message stores
	*/
	var messages = [JSQMessage]()
	
	var navBar :UINavigationBar!
	/** User should be passed when entering the chat view*/
	var chatUser: NSDictionary!
	var meDataSource: MeDataSource!
	var msgDataSource: MessageDataSource!
	var myId: String!
	var otherId: String!
	// TODO: have userId of me and the other user
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.msgDataSource = MessageDataSource(room: room)
		self.setup()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		// TODO: First initialize the messages with local ones from MessageDataSource:
		// self.messages = MessageDataSource.xxx
		
		DataSourceStore.socketIODataSource.subscribeToRoom(room) { messages in
			for message in messages {
				self.messages.append(message)
			}
			self.reloadData()
		}
		
		DataSourceStore.socketIODataSource.getChatMessage { message in
			DispatchQueue.main.async(execute: { () -> Void in
				if message != nil {
					self.messages.append(message!)
					self.reloadData()
				}
			})
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/** Come up with the required init method*/
	func initUser(_ user: NSDictionary) {
		self.chatUser = user
		self.meDataSource = DataSourceStore.meDataSource
		// TODO : Get the id from JWT instead of API
		
		myId = meDataSource.userInfoItem.id
		otherId = user[UserCardInfo.id] as! String
		/**change id to user's id**/
		self.senderId = myId
		self.senderDisplayName = user[UserCardInfo.username] as! String
		let ids: [String] = [myId, otherId]
		let sortedids = ids.sorted()
		self.room = sortedids[0] + "-" + sortedids[1]
		print("New room: " + self.room)
	}
	
	// not used; for reference
	/*
	func addDemoMessages() {
	for i in 1...10 {
	let sender = (i%2 == 0) ? "Server" : self.senderId
	let messageContent = "Message nr. \(i)"
	let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
	self.messages += [message]
	}
	self.reloadData()
	}
	*/
	
	/**func setup()
	sets up UI*/
	func setup() {
		
		self.topContentAdditionalInset = 60.0
		/**this id is used to differentiate if the message is coming from the user or the other person*/
		//self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
		//self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
		
		let screenSize: CGRect = UIScreen.main.bounds
		self.navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: navBarHeight))
		// TODO: change the color of the navBar according to the design
		navBar?.backgroundColor = UIColor.purple
		let navItem = UINavigationItem(title: String(describing: chatUser![UserCardInfo.username]))
		// TODO: change the style of the button to be back arrow "<"
		let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissView))
		navItem.leftBarButtonItem = backItem
		navBar!.setItems([navItem], animated: false)
		self.view.addSubview(navBar!)
		automaticallyScrollsToMostRecentMessage = true
	}
	
	// MARK: MsgDS delegate method
	func reloadData() {
		self.collectionView?.reloadData()
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.messages.count
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
		let data = self.messages[indexPath.row]
		return data
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
		self.messages.remove(at: indexPath.row)
		// TODO: delete local storage if delete here and refresh
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
		let data = messages[indexPath.row]
		switch(data.senderId) {
		case self.senderId:
			return self.outgoingBubble
		default:
			return self.incomingBubble
		}
	}
	
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
		return nil
	}
	
	override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
		let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
		DataSourceStore.socketIODataSource.sendMessage(self.room, message: message!)
		// TODO : create a function to transform between two kinds of messages
		// msgDataSource.addMessage(<#T##msg: Message##Message#>)(message)
		self.messages.append(message!)
		self.finishSendingMessage()
	}
	
	override func didPressAccessoryButton(_ sender: UIButton!) {
		// TODO: add icons for sending files like picture?
	}
	
	func dismissView() -> Void {
		self.dismiss(animated: true, completion: nil)
	}
}
