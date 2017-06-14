//
//  Configuration.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

#if !DEBUG
	func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") { }
	func print(_ items: Any..., separator: String = " ", terminator: String = "\n") { }
#endif
