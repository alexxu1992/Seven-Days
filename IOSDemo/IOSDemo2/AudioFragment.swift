//
//  AudioItemFragment.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class AudioFragment: AbstractFragment {
	var audioItem: AudioItem!
	var audioTitleLabel: UILabel!
	var deleteButton: DeleteButton!
	var index: Int!
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.audioTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.75, height: frame.size.height))
		self.deleteButton = DeleteButton(frame: CGRect(x: frame.size.width * 0.8, y: frame.size.height / 4, width: frame.size.width * 0.15, height: frame.size.height / 2))
		
		contentView.addSubview(self.audioTitleLabel)
		contentView.addSubview(deleteButton)
	}
	
	override func updateWithItem(_ item: Item, index: Int) {
		let audioItem = item as! AudioItem
		self.index = index
		self.audioItem = audioItem
		self.audioTitleLabel.text = audioItem.audioTitle
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


struct AudioItemPropertyKey {
	static let audioAssetStringKey = "audioAssetString"
	static let audioTitleKey = "audioTitle"
	static let isLocalFileKey = "isLocalFile"
	static let idKey = "id"
}

class AudioItem: NSObject, NSCoding, Item {
	
	// MARK : Properties
	var audioAssetString: String
	var audioTitle: String
	var isLocalFile: Bool
	var id: String
	
	// MARK : Archiving Paths
	static let CACHE_URL: URL = getLocalFileURLWithPath(CACHE_FILE_NAME.AUDIO_ITEMS, baseURL: LOCAL_PATHS.CACHE)
	
	init?(audioAssetString: String, audioTitle: String, isLocalFile: Bool, id: String) {
		if (audioTitle.isEmpty) {
			return nil
		}
		self.audioAssetString = audioAssetString
		self.audioTitle = audioTitle
		self.isLocalFile = isLocalFile
		self.id = id
	}
	
	convenience init?(audioAssetString: String, audioTitle: String, isLocalFile: Bool) {
		self.init(audioAssetString: audioAssetString, audioTitle: audioTitle, isLocalFile: isLocalFile, id: "")
	}
	
	convenience init?(audioAssetString: String, audioTitle: String) {
		self.init(audioAssetString: audioAssetString, audioTitle: audioTitle, isLocalFile: false, id: "")
	}
	
	convenience init?(audioAssetString: String) {
		self.init(audioAssetString: audioAssetString, audioTitle: "No Title")
	}
	
	convenience init?(item: MPMediaItem) {
		if let url = item.assetURL {
            let str = url.absoluteString
			if let title = item.title {
				self.init(audioAssetString: str, audioTitle: title)
			} else {
				self.init(audioAssetString: str)
			}
		} else {
			return nil
		}
	}
	
	// MARK: NSCoding
	required convenience init? (coder aDecoder: NSCoder) {
		let audioAssetString = aDecoder.decodeObject(forKey: AudioItemPropertyKey.audioAssetStringKey) as! String
		let audioTitle = aDecoder.decodeObject(forKey: AudioItemPropertyKey.audioTitleKey) as! String
		let isLocalFile = aDecoder.decodeObject(forKey: AudioItemPropertyKey.isLocalFileKey) as! Bool
		let id = aDecoder.decodeObject(forKey: AudioItemPropertyKey.idKey) as! String
		self.init(audioAssetString: audioAssetString, audioTitle: audioTitle, isLocalFile: isLocalFile, id: id)
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(audioAssetString, forKey: AudioItemPropertyKey.audioAssetStringKey)
		aCoder.encode(audioTitle, forKey: AudioItemPropertyKey.audioTitleKey)
		aCoder.encode(isLocalFile, forKey: AudioItemPropertyKey.isLocalFileKey)
		aCoder.encode(id, forKey: AudioItemPropertyKey.idKey)
	}
	
	// MARK: Methods
	func recycle() {
		if let url = audioAssetURL(), self.isLocalFile {
			deleteFileAtURL(url)
		}
	}
	
	func audioAssetURL() -> URL? {
		return isLocalFile ? getLocalFileURLWithPath(audioAssetString, baseURL: LOCAL_PATHS.AUDIO) : URL(string: audioAssetString)
	}
}
