//
//  AsyncInitStep.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 3/6/17.
//  Copyright © 2017 Nan Guo. All rights reserved.
//

import Foundation

protocol AsyncInitStep: class {
	func asyncInit(_ completionHandler: ((AnyObject) -> Void))
}
