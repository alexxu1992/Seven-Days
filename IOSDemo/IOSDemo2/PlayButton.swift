//
//  PlayButton.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class PlayButton: UIButton {
	enum PlayState {
		case play
		case pause
		case stop
		case record
	}
	var currentState: PlayState!
	init(frame: CGRect, currentState:PlayState, target: UIViewController, action: Selector) {
		super.init(frame: frame)
		self.currentState = currentState
		changeState(currentState)
		self.setTitleColor(UIColor.blue, for: UIControlState())
		self.addTarget(target, action: action, for: .touchUpInside)
		self.backgroundColor = UIColor.lightGray
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func changeState(_ state: PlayState) {
		self.currentState = state
		switch state {
		case .play:
			self.setTitle("Play", for: UIControlState())
		case .pause:
			self.setTitle("Pause", for: UIControlState())
		case .stop:
			self.setTitle("Stop", for: UIControlState())
		case .record:
			self.setTitle("Record", for: UIControlState())
		default:
			return
		}
	}
}
