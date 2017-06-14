//
//  Chapter.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

class Chapter: BookItem {
	var articles: [Article]
	let book: Book
	
	init(type: BookItem.ItemType, id: String, index: Int, title: String, articles: [Article], book: Book) {
		self.articles = articles
		self.book = book
		super.init(type: type, id: id, index: index, title: title)
	}
}
