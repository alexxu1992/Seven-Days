//
//  BookFragment.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

// TODO: Uncompleted
open class BookFragment: UICollectionViewCell {
	var item: BookItem!
	var titleLabel: UILabel!
	
	
	func updateWithItem(_ item: BookItem) {
		self.item = item
		var titleText = ""
		switch item.type {
		case .Article:
			titleText += "-------- Article: "
		case .Book:
			titleText += "Book: "
		case .Chapter:
			titleText += "---- Chapter: "
		}
		titleText += item.title
		self.titleLabel.text = titleText
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.75, height: frame.size.height))
		contentView.addSubview(titleLabel)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
