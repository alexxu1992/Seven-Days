//
//  MeDataSource.swift
//  IOSDemo2
//
//  Created by 陈科宇 on 16/10/7.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

var avatarData: Data!

protocol MeDataSourceDelegate: class {
    func reloadData()
}

class MeDataSource: AsyncInitStep {
    weak var delegate: MeDataSourceDelegate?
    var userInfoItem: UserInfoItem!
	var nameCards: [String: AnyObject]!
    
    func loadUserInformation(_ completionHandler: @escaping ((Void) -> Void)) {
        let relativeURL = "/api/users/me/"
        let request = getRequestConfig(nil, apiRelativeURL: relativeURL)

        sendURLRequest(request!) { (returnData) in
			self.nameCards = returnData[UserCardInfo.namecard] as! [String : AnyObject]
            let username = returnData[UserCardInfo.username] as! String
            let avatar = returnData[UserCardInfo.avatarURL] as! String
            let id = returnData[UserCardInfo.id] as! String
            if username != "" && avatar != "" && id != ""  {
                self.userInfoItem = UserInfoItem(id: id, username: username, avatar: avatar)
            }
			completionHandler()
        }
    }
    
    func uploadUserInformation(){
        let relativeURL = "/api/users/me"
        let uploadData = ["username":userInfoItem.username]
        let request = putRequestConfig(uploadData as NSDictionary, apiRelativeURL: relativeURL)
        sendURLRequest(request!) { (returnData) in
           //TODO: handle upload failure here
        }
    }
    func uploadAvatar () -> AnyObject? {
        // This task is asynchronous and in some places we may need synchronous task, so add Semaphore to control
        //let dataSemaphore = dispatch_semaphore_create(0)
        let relativeURL = "/api/users/avatar/"
        let URL = SEVERURL + relativeURL
        let boundary = "----thisisricky--"
        let fname = "avatar.png"
        let mimetype = "image/png"
        let body = NSMutableData()
        var resultData: AnyObject?
        let request = NSMutableURLRequest(url:Foundation.URL(string:URL)!)
        
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"avatar\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        //body.appendData("avatar:".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.append(avatarData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(TOKEN, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                print("u have error here")
                print("Error -> \(error)")
                return
            }
            
            do {
                let logData = String(data: NSData(data: data!) as Data, encoding: String.Encoding.utf8)
                NSLog(logData!)
                
                let outcome = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                print(outcome)
                if let result = outcome as? [String: AnyObject] {
                    if let success = result[CommonInfo.success] as? Int {
                        if success == 1 {
                            if let returnData = result[CommonInfo.data] {
                                resultData = returnData
                            } else {
                                resultData = true
                            }
                            //dispatch_semaphore_signal(dataSemaphore)
                        }
                        else {
                            // Error Handler? Maybe pass in and call a specific delegate from a DS
                            print("we send out the request but receive false")
                            resultData = result[CommonInfo.errorCode]
                            //dispatch_semaphore_signal(dataSemaphore)
                        }
                    }
                }
                //dispatch_semaphore_signal(dataSemaphore)
            } catch {
                print("Error -> \(error)")
                //dispatch_semaphore_signal(dataSemaphore)
            }
        }) 
        task.resume()
        //dispatch_semaphore_wait(dataSemaphore, DISPATCH_TIME_FOREVER) // This will block the app, I think it's not good
        return resultData
    }
	
	// MARK: AsyncInitStep protocol
	func asyncInit(_ completionHandler: ((AnyObject) -> Void)) {
		self.loadUserInformation() {
			completionHandler(NSNull)
		}
	}
}
