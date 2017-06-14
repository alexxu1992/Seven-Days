//
//  AbstractFragment.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 11/12/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

// TODO: Uncompleted
open class AbstractFragment: UICollectionViewCell {
	func updateWithItem(_ item: Item, index: Int) {
		preconditionFailure("This method must be overrided")
	}
}
