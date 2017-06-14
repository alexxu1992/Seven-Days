//
//  GlobalConstants.swift
//  IOSDemo2
//
//  Created by Xuhui Xu on 6/16/16.
//  Copyright © 2016 Nanguo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Screen Sizes
let SCREEN_SIZE: CGRect = UIScreen.main.bounds
let SCREEN_HEIGHT = SCREEN_SIZE.height
let SCREEN_WIDTH = SCREEN_SIZE.width

// MARK: - File System
/*
This will look like /var/mobile/Containers/Data/Application/2EC4B4A8-5C64-4238-8D50-B9821665B488/Documents/
Note that the random app id is DIFFERENT every time the app is installed/updated
Thus DO NOT SAVE ABSOLUTE PATH AS URL but only file name!
*/
let LOCAL_DOC_PATH: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

struct LOCAL_PATHS {
	static let AUDIO = LOCAL_DOC_PATH + "/Audio"
	static let CACHE = LOCAL_DOC_PATH + "/Cache"
    static let PHOTO = LOCAL_DOC_PATH + "/Photo"
}

struct CACHE_FILE_NAME {
	static let AUDIO_ZIP = "Audio.zip"
	static let AUDIO_ITEMS = "AudioItems"
	static let ARTICLE_ITEMS = "ArticleItem_Deprecateds"
}

// MARK: - Web Interface Configuration
let SEVERURL = "http://54.149.93.191:8080"
var TOKEN = ""
// var TOKEN: String = "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1NzY2NTIzY2U1M2M4YzlhMGVkNTY5OWIiLCJpYXQiOjE0NjYzMzcxNTYsImV4cCI6MTQ2Njk0MTk1Nn0.Jt61sDTCpTuLVqyVAqTi1F_Qu4_uQMj4E9HtCN719D0"

// MARK: - Error Strings
// TODO: need some more formal and robust error handling methods
// Option: Change struct to enums
struct ERROR {
	static let NO_MESSAGE = "No Message"
	static let WRONG_EMAIL_FORMAT = "Wrong Email Format"
	static let WRONG_PASSWORD = "Password must between 6-32 characters"
	static let WRONG_USERNAME = "Username must between 1-10 characters and only allow normal characters along _"
	static let WRONG_GENDER = "Gender 1 for male and 2 for female"
	static let UNKNOWN_ERROR = "Unknown Error!"
    static let SERVER_ERROR = "Unable to connect!"
}

enum ThrowableError: Error {
    typealias RawValue = String

	case illegalArgument(String)
	
}

// MARK: - Common Strings
struct COMMON {
	static let ERROR = "Error"
	static let OK = "OK"
}

