//
//  BookItem.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

class BookItem {
	enum ItemType: String {
		case Book
		case Chapter
		case Article
	}
	var index: Int
	var title: String
	var id: String
	var type: ItemType
	
	init(type: ItemType, id: String, index: Int, title: String) {
		self.type = type
		self.title = title
		self.index = index
		self.id = id
	}
}
