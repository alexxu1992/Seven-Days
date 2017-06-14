//
//  Paragraph.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation

class Paragraph {
	enum ItemType: String {
		case Text
		case Audio
		case Video
		case Image
	}
	
	let type: ItemType
	var content: String
	var assetUrl: String
	
	
	static let CACHE_URL: URL = getLocalFileURLWithPath(CACHE_FILE_NAME.ARTICLE_ITEMS, baseURL: LOCAL_PATHS.CACHE)
	
	init(type: ItemType, content: String, assetUrl: String) {
		self.type = type
		self.content = content
		self.assetUrl = assetUrl
		//super.init(id: id, index: index, title: title)
	}
	
	// MARK: methods
	func isLocalFile() -> Bool {
		return assetUrl.hasPrefix("file://");
	}
	
	func recycle() {
		if isLocalFile() {
			deleteFileAtURL(getAssetURL())
		}
	}
	
	func getAssetURL() -> URL {
		return isLocalFile() ? getLocalFileURLWithPath(assetUrl, baseURL: LOCAL_PATHS.CACHE): URL(string: assetUrl)!
	}
	
	// MARK: NSCoding
	// TODO: The NSCoding is not felxible enough to handle the book structure, consider implement JSON serialization method for the entire book
	fileprivate struct ParagraphPropertyKeys {
		static let typeKey = "typeKey"
		static let contentKey = "contentKey"
		static let assetUrlKey = "assetUrlKey"
	}
	
	required convenience init? (coder aDecoder: NSCoder) {
		
		let type = ItemType(rawValue:aDecoder.decodeObject(forKey: ParagraphPropertyKeys.typeKey) as! String)
		let content = aDecoder.decodeObject(forKey: ParagraphPropertyKeys.contentKey) as! String
		let assetUrl = aDecoder.decodeObject(forKey: ParagraphPropertyKeys.assetUrlKey) as! String
		
		self.init(type: type!, content: content, assetUrl: assetUrl)
	}
	
	func encodeWithCoder(_ aCoder: NSCoder) {
		aCoder.encode(type.rawValue, forKey: ParagraphPropertyKeys.typeKey)
		aCoder.encode(content, forKey: ParagraphPropertyKeys.contentKey)
		aCoder.encode(assetUrl, forKey: ParagraphPropertyKeys.assetUrlKey)
	}
	
}
