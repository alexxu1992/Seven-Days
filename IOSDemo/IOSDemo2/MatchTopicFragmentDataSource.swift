//
//  MatchDirectionDS.swift
//  IOSDemo
//
//  Created by Chi Yang on 7/28/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol MatchTopicFragmentDataSourceDelegate: class {
	func reloadData()
	func goToMeetUserPage(_ userCard: NSDictionary)
	func goToFindMorePage(_ userCard: NSDictionary)
    func showAlert(_ title: String, message: String)
}
// extension to protocol for optional methods
extension MatchTopicFragmentDataSourceDelegate {
	func reloadData() { }
	func goToMeetUserPage(_ userCard: NSDictionary) { }
	func goToFindMorePage(_ userCard: NSDictionary) { }
    func showAlert(_ title: String, message: String) {}
}

class MatchTopicFragmentDataSource: AsyncInitStep {
	var thedatesTopic: Array<MatchTopic> = []
	weak var delegate: MatchTopicFragmentDataSourceDelegate?

    var findMoreCount:Int = 0
    
    func loadMatchTopic(_ completionHandler: @escaping ((Void) -> Void)) {
		let dateObject: [String: String] = [MatchTopicInfo.timestamp: getCurrentTimeStamp()]
		let relativeURL = "/api/matches/topics"
        
		let request = getRequestConfig(dateObject, apiRelativeURL: relativeURL)
        sendURLRequest(request!) { (returnData) in
            self.thedatesTopic = self.parseMatchTopic(returnData as! NSArray)
            completionHandler()
        }
	}

	func parseMatchTopic(_ topicArr: NSArray) -> Array<MatchTopic> {
		var returnArr: Array<MatchTopic> = []

		for topic in topicArr {
			if let dict = topic as? NSDictionary {
				let aTopic = MatchTopic.init(mainClass: dict)
				returnArr.append(aTopic)
			}
		}
		return returnArr
	}

	func goToMeet(_ topic_id: String, answer_id: Int) {
		// TODO: post to get the user card; also need a delegate method to segue the view to user info
		let relativeURL = "/api/matches/gotomeet"
		let body: [String: String] = [MatchGoToMeetInfo.topic_id: topic_id,
			MatchGoToMeetInfo.answer_id: String(answer_id)]
		let request = postRequestConfig(body, apiRelativeURL: relativeURL)
        sendURLRequest(request!) { (returnData) in
            if let returnTopics = returnData[MatchGoToMeetInfo.user] as! NSDictionary? {
                self.findMoreCount = 0
                self.delegate?.goToMeetUserPage(returnTopics)
            }
        }
	}

	func findMore() {
		let relativeURL = "/api/matches/findmore"
		let request = postRequestConfig(["": ""], apiRelativeURL: relativeURL)
        sendURLRequest(request!) { (response) in
            if let returnUser = response[MatchGoToMeetInfo.user] as! NSDictionary? {
                // TODO: refresh this page with the find more info
                self.findMoreCount += 1
                self.delegate?.goToFindMorePage(returnUser)
                // maybe hide the find more button
            }

        }
	}

    func engageUser(_ userId: String) {
        let relativeURL = "/api/engages/engage"
        let request = postRequestConfig([UserCardInfo.id: userId], apiRelativeURL: relativeURL)
        sendURLRequest(request!) { (response) in
            if response is Bool {
                if response as! NSObject == true {
                    self.delegate?.showAlert("Congratulations!", message: "You have Successcullly engaged this user")
                } else {
                    self.delegate?.showAlert("Error", message: "Failed to engage this user")
                }
            }
        }
    }

    func reloadData() {
        delegate?.reloadData()
    }
    
    func asyncInit(_ completionHandler: ((AnyObject) -> Void)) {
        self.loadMatchTopic() {
            completionHandler(NSNull)
        }
    }
}

