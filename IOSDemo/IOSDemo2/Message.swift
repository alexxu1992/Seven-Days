//
//  Message.swift
//  IOSDemo2
//
//  Created by Chi Yang on 1/28/17.
//  Copyright © 2017 Nan Guo. All rights reserved.
//

import Foundation
import RealmSwift

enum MessageType: Int{
    case text, image, audio, video, file, app
}

class Message: Object {
    /**msg id*/
    dynamic var id = ""
    dynamic var content = ""
    /**time_t*/
    dynamic var created = Date()
    /**MessageType enum (@obj since Realm is in obj-c)
     https://github.com/realm/realm-cocoa/issues/921 */
    dynamic var type: MessageType = .unknown
    @objc enum MessageType: Int {
        case unknown, text, image, audio, video, file, app
    }
    /**room of the chat*/
    dynamic var room = ""
    /**Sender's UserID*/
    dynamic var senderId = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
