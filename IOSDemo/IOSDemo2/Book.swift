//
//  Book.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

class Book: BookItem {
	let isMine: Bool
	var chapters: [Chapter]
	
	init(type: BookItem.ItemType, id: String, isMine: Bool, index: Int, title: String, chapters: [Chapter]) {
		self.isMine = isMine
		self.chapters = chapters
		super.init(type: type, id: id, index: index, title: title)
	}
}
