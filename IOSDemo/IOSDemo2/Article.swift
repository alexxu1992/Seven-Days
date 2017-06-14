//
//  Article.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

class Article: BookItem {
	let chapter: Chapter
	var paragraphs: [Paragraph]
	
	init(type: BookItem.ItemType, id: String, index: Int, title: String, paragraphs: [Paragraph], chapter: Chapter) {
		self.paragraphs = paragraphs
		self.chapter = chapter
		super.init(type: type, id: id, index: index, title: title)
	}
}
