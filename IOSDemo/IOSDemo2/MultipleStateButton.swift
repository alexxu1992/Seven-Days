//
//  MultipleStateButton.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class MultipleStateButton: UIButton {
	var stateDict: [String: String]!
	var currentState: String!
	
	init(frame: CGRect, stateDict: [String: String], currentState: String, target: UIViewController, action: Selector) {
		super.init(frame: frame)
		self.currentState = currentState
		self.stateDict = stateDict
		changeState(currentState)
		self.setTitleColor(UIColor.blue, for: UIControlState())
		self.addTarget(target, action: action, for: .touchUpInside)
		self.backgroundColor = UIColor.lightGray
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func changeState(_ state: String) {
		self.currentState = state
		self.setTitle(stateDict[state], for: UIControlState())
	}
}
