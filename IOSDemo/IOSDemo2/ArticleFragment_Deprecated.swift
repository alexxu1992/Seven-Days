//
//  ArticleFragment_Deprecated.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/15/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class ArticleFragment_Deprecated: AbstractFragment {
	var articleItem: ArticleItem_Deprecated!
	var articleTitleLabel: UILabel!
	var deleteButton: DeleteButton!
	var index: Int!
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.articleTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.75, height: frame.size.height))
		self.deleteButton = DeleteButton(frame: CGRect(x: frame.size.width * 0.8, y: frame.size.height / 4, width: frame.size.width * 0.15, height: frame.size.height / 2))
		
		contentView.addSubview(self.articleTitleLabel)
		contentView.addSubview(deleteButton)
	}
	
	override func updateWithItem(_ item: Item, index: Int) {
		let articleItem = item as! ArticleItem_Deprecated
		self.index = index
		self.articleItem = articleItem
		self.articleTitleLabel.text = articleItem.articleTitle
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct ArticleItem_DeprecatedPropertyKey {
	static let articleTitleKey = "articleTitle"
	static let articleBodyKey = "articleBody"
	static let idKey = "id"
}

class ArticleItem_Deprecated: NSObject, NSCoding, Item {
	
	// MARK : Properties
	var articleTitle: String
	var articleBody: String
	var id: String
	
	// MARK : Archiving Paths
	static let CACHE_URL: URL = getLocalFileURLWithPath(CACHE_FILE_NAME.ARTICLE_ITEMS, baseURL: LOCAL_PATHS.CACHE)
	
	init?(articleTitle: String, articleBody: String, id: String) {
		if (articleTitle.isEmpty) {
			return nil
		}
		self.articleTitle = articleTitle
		self.articleBody = articleBody
		self.id = id
	}
	
	// MARK: NSCoding
	required convenience init? (coder aDecoder: NSCoder) {
		let articleTitle = aDecoder.decodeObject(forKey: ArticleItem_DeprecatedPropertyKey.articleTitleKey) as! String
		let articleBody = aDecoder.decodeObject(forKey: ArticleItem_DeprecatedPropertyKey.articleBodyKey) as! String
		let id = aDecoder.decodeObject(forKey: ArticleItem_DeprecatedPropertyKey.idKey) as! String
		self.init(articleTitle: articleTitle, articleBody: articleBody, id: id)
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(articleTitle, forKey: ArticleItem_DeprecatedPropertyKey.articleTitleKey)
		aCoder.encode(articleBody, forKey: ArticleItem_DeprecatedPropertyKey.articleBodyKey)
		aCoder.encode(id, forKey: ArticleItem_DeprecatedPropertyKey.idKey)
	}
	
}
