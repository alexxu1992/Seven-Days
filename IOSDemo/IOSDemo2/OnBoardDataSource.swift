//
//  OnBoardDataSource.swift
//  IOSDemo
//
//  Created by  Eric Wang on 8/16/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

typealias onBoardCompletionHandler = (_ error: String) -> Void

enum OnBoardDataType {
	case email
	case password
	case username
	case gender
}

class OnBoardDataObject {
	var email: String?
	var password: String?
	var username: String?
	var gender: String?

	init(email: String?, password: String?, username: String?, gender: String?) {
		self.email = email
		self.password = password
		self.username = username
		self.gender = gender
	}

	convenience init(email: String?, password: String?) {
		self.init(email: email, password: password, username: nil, gender: nil)
	}

	func toDictionary() -> [String: String] {
		var dic: [String: String] = [:]
		if (self.email != nil) {
			dic["email"] = self.email
		}
		if (self.password != nil) {
			dic["password"] = self.password
		}
		if (self.username != nil) {
			dic["username"] = self.username
		}
		if (self.gender != nil) {
			dic["gender"] = self.gender
		}
		return dic
	}

	func checkInputError() -> String? {
		if (self.email != nil) {
			if (!type(of: self).checkInputStringWithDataType(OnBoardDataType.email, inputString: self.email!)) {
				return ERROR.WRONG_EMAIL_FORMAT
			}
		}
		if (self.password != nil) {
			if (!type(of: self).checkInputStringWithDataType(OnBoardDataType.password, inputString: self.password!)) {
				return ERROR.WRONG_PASSWORD
			}
		}
		if (self.gender != nil) {
			if (!type(of: self).checkInputStringWithDataType(OnBoardDataType.gender, inputString: self.gender!)) {
				return ERROR.WRONG_GENDER
			}
		}
		if (self.username != nil) {
			if (!type(of: self).checkInputStringWithDataType(OnBoardDataType.username, inputString: self.username!)) {
				return ERROR.WRONG_USERNAME
			}
		}
		return nil
	}

	class func checkInputStringWithDataType(_ dataType: OnBoardDataType, inputString: String) -> Bool {
		do {
			var pattern: String
			switch dataType {
			case .email:
				pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
			case .gender:
				pattern = "(1|2)"
			case .password:
				pattern = "^[\\w\\!\\@\\#\\$\\%\\^\\&\\*\\.\\:\\;]{6,32}$"
			case .username:
				pattern = "^\\w{1,10}$"
			}
			let regex: NSRegularExpression =
				try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
			let stringRange = NSMakeRange(0, inputString.characters.count)
			let match = regex.firstMatch(in: inputString, options: NSRegularExpression.MatchingOptions.reportProgress, range: stringRange)
			return match != nil && (match!.range.location == stringRange.location) && (match!.range.length == stringRange.length)

		} catch {
			return false
		}

	}
}

class OnBoardDataSource {
	
	// MARK: Check Email & Username
	func checkServerErrorForDataObject(_ dataObject: OnBoardDataObject, apiRelativeURL: String, completionHandler: @escaping onBoardCompletionHandler) {
		// Format Check
		if let err = dataObject.checkInputError() {
			completionHandler(err)
		}
		
		let request = postRequestConfig(dataObject.toDictionary(), apiRelativeURL: apiRelativeURL)
		
		sendURLRequest(request!) { (returnData) in
			if let judge = returnData as? Bool {
				if judge {
					completionHandler("")
				}
			} else {
				if let err = returnData as? String {
					print(err)
					completionHandler(err)
				}
			}
		}
		
	}
	
	// MARK: Sign Up -> Return error if exists
	func signUp(_ signUpDataObject: OnBoardDataObject, completionHandler: @escaping onBoardCompletionHandler) {
		// Format Check
		if let err = signUpDataObject.checkInputError() {
			completionHandler(err)
		}
		
		let request = postRequestConfig(signUpDataObject.toDictionary(), apiRelativeURL: "/api/users/signup")
		
		sendURLRequest(request!) { (returnData) in
			if returnData as? [String: AnyObject] != nil {
				completionHandler("")
			} else {
				if let err = returnData as? String {
					print(err)
					completionHandler(err)
				}
			}
		}
	}
	
	// MARK: Login -> Return error if exists
	
	func login(_ loginDataObject: OnBoardDataObject, completionHandler: @escaping onBoardCompletionHandler) {
		if let err = loginDataObject.checkInputError() {
			completionHandler(err)
		}
		
		let request = postRequestConfig(loginDataObject.toDictionary(), apiRelativeURL: "/api/users/signin")
		
		sendURLRequest(request!) { (returnData) in
			if let data = returnData as? [String: AnyObject] {
				if let token = data[LoginInfo.token] as? String {
					TOKEN = token
					DataSourceStore.initDataSourcesAfterLogin() {
						completionHandler("")
					}
				}
			} else {
				if let err = returnData as? String {
					print(err)
					completionHandler(err)
				}
			}
		}
	}
}
//TODO: Implement Logout method
