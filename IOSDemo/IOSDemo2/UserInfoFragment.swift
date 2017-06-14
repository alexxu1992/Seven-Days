//
//  UserInfoItem.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

class UserInfoItem {
    var id:String = ""
    var username: String = ""
    var age: String = "0"
    var college: String = "SJTU"
    var occupation: String = "Student"
    var avatar: String = ""
    /// many of the variables are not init while calling me api
    init(username: String, age: String, college: String, occupation: String, avatar: String){
        self.username = username
        self.age = age
        self.college = college
        self.occupation = occupation
        self.avatar = avatar
    }

    /**User Id is used for chatting*/
    init(id:String, username: String, avatar: String) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
