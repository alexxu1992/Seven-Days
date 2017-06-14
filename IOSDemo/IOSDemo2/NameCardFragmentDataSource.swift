//
//  NameCardFragmentDataSource.swift
//  IOSDemo
//
//  Created by  Eric Wang on 7/25/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

protocol NameCardFragmentDataSourceDelegate: class {
	func reloadData()
}

class NameCardFragmentDataSource: AsyncInitStep {
	weak var delegate: NameCardFragmentDataSourceDelegate?
    var engageList: NSArray = []
        
    func loadNameCardListData(_ completionHandler: ((Void) -> Void)) {
		let relativeURL = "/api/engages/getlist/"
		let request = getRequestConfig(nil, apiRelativeURL: relativeURL)
        
        sendURLRequest(request!) { (returnData) in
            if let data = returnData[EngageDirectionInfo.engagesList] as! NSArray? {
                self.engageList = data
            }
			completionHandler()
        }
	}
	
	// MARK: AsyncInitStep protocol
	func asyncInit(_ completionHandler: ((AnyObject) -> Void)) {
		self.loadNameCardListData() {
			completionHandler(NSNull)
		}
	}
}
