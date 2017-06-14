//
//  WebInterface.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 7/9/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import Alamofire
import SocketIO

func processResponseData(_ response: AnyObject) -> AnyObject? {
    var resultData: AnyObject?
    do {
        
        let outcome = try JSONSerialization.jsonObject(with: response as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        print(outcome)
        if let result = outcome as? [String: AnyObject] {
            if let success = result[CommonInfo.success] as? Int {
                if success == 1 {
                    if let returnData = result[CommonInfo.data] {
                        resultData = returnData
                    } else {
                        resultData = true as AnyObject
                    }
                }
                else {
                    print(ERROR.SERVER_ERROR)
                    resultData = result[CommonInfo.errorCode]
                }
            }
        }
    } catch let error as NSError {
        print(error)
    }
    return resultData
}

//MARK: Request configuration
func getRequestConfig(_ params: [String: String]?, apiRelativeURL: String) -> NSMutableURLRequest? {
    var apiAbsoluteUrl = SEVERURL + apiRelativeURL

    if params != nil && params!.count != 0 {
        apiAbsoluteUrl += "?";
        for (key, value) in params! {
            apiAbsoluteUrl += (key + "=" + value + "&")
        }
    }
    apiAbsoluteUrl.remove(at: apiAbsoluteUrl.characters.index(before: apiAbsoluteUrl.endIndex)); // Remove last '&'
    let request = NSMutableURLRequest(url: URL(string: apiAbsoluteUrl)!)
    request.httpMethod = "GET"
    return request
}

func postRequestConfig(_ params: [String: String], apiRelativeURL: String) -> NSMutableURLRequest? {
    let paramsJSONString = JSONStringify(params as AnyObject)
    let apiAbsoluteUrl = SEVERURL + apiRelativeURL;
    let request = NSMutableURLRequest(url: URL(string: apiAbsoluteUrl)!)
    request.httpMethod = "POST"
    request.httpBody = paramsJSONString.data(using: String.Encoding.utf8)
    return request
}

func putRequestConfig(_ params: NSDictionary, apiRelativeURL: String) -> NSMutableURLRequest? {
    let apiAbsoluteUrl = SEVERURL + apiRelativeURL;
    let request = NSMutableURLRequest(url: URL(string: apiAbsoluteUrl)!)
    do {
        let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions(rawValue: 0))
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "PUT"
        return request
    } catch {
        print("Error converting params in putRequestConfig()")
    }
    return nil
}

//MARK: Send request
func sendURLRequest(_ request: NSMutableURLRequest, completionHandler: @escaping ((AnyObject) -> Void)) {
    anthorizeRequest(request)
    Alamofire.request(request as! URLRequestConvertible).response {response in
        if let data = response.data{
            let logData = String(data: NSData(data: data) as Data, encoding: String.Encoding.utf8)
            print(logData!)
            if let processedResponseData = processResponseData(data as AnyObject) {
                completionHandler(processedResponseData)
            } else {
                print("ERROR")
            }
        }
        
    }
}

//TODO: deprecate get/put/postRequestConfig and use the method below
func sendURLRequest(_ method: Alamofire.Method, urlString: URLConvertible, parameters: [String: AnyObject], encoding: Alamofire.ParameterEncoding, headers: [String: String], completionHandler: @escaping ((AnyObject) -> Void)) {
    
    Alamofire.request(method, urlString, parameters: parameters, encoding: encoding, headers: nil).response { (request, response, data, error) in
        let logData = String(data: NSData(data: data!), encoding: NSUTF8StringEncoding)
        print(logData!)
        if let processedResponseData = processResponseData(data!) {
            completionHandler(processedResponseData)
        } else {
            print(ERROR.SERVER_ERROR)
        }
    }
}

//MARK: helper functions
func anthorizeRequest(_ request: NSMutableURLRequest) {
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(TOKEN, forHTTPHeaderField: "Authorization")
}

func requestURL(_ params: [String: String]?, apiRelativeURL: String) -> NSString {
    var apiAbsoluteUrl = SEVERURL + apiRelativeURL
    
    if params != nil && params!.count != 0 {
        apiAbsoluteUrl += "?";
        for (key, value) in params! {
            apiAbsoluteUrl += (key + "=" + value + "&")
        }
    }
    apiAbsoluteUrl.remove(at: apiAbsoluteUrl.characters.index(before: apiAbsoluteUrl.endIndex)); // Remove last '&'
    return apiAbsoluteUrl as NSString
}

