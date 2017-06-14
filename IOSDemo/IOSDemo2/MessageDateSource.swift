//
//  MessageDateSource.swift
//  IOSDemo2
//
//  Created by Chi Yang on 1/28/17.
//  Copyright © 2017 Nan Guo. All rights reserved.
//

import Foundation
import RealmSwift

protocol MessageDataSourceDelegate: class {
    func reloadData()
}

class MessageDataSource {

    var room: String = ""
    weak var delegate: MessageDataSourceDelegate?

    let realm = try! Realm()
    lazy var messages: Results<Message> = { self.realm.objects(Message) }()

    // TODO: refresh and retrieve say 30 more msg
    required init(room : String){
        self.room = room
        populateMessages()
    }

    /**Retrieve messages from local db with the room*/
    func populateMessages() {
        let realm = try! Realm()
        let query = "room == '" + room + "'"
        messages = realm.objects(Message.self).filter(query) // 5
        reloadData()
    }

    /**Update: No need to update for sent msgs*/

    /**Add*/
    func addMessage(_ msg: Message){
        try! realm.write {
            realm.add(msg)
        }
    }

    /**Delete*/
    func deleteMessage(_ msg: Message){
        try! realm.write {
            realm.delete(msg)
        }
    }
    /**Delete All*/
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func reloadData() {
        delegate?.reloadData()
    }
}
