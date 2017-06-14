//
//  MatchTopicFragment.swift
//  IOSDemo2
//
//  Created by Xuhui Xu on 6/30/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit

public struct MatchTopic {
	var topic_id: String?
	var title: String?
	var subtitle: String?
	var story: String?
	var pictureURL: String?
	// answers is an Array of Dictionary
	// {["1":"first answer"],
	// ["2":"second answer"],
	// ...}
	var answers = [String]()
	var bgImage: UIImage?

	init(mainClass: NSDictionary?) {
		self.title = mainClass![MatchTopicInfo.title] as? String
		self.subtitle = mainClass![MatchTopicInfo.subtitle] as? String
		self.story = mainClass![MatchTopicInfo.story] as? String
		self.pictureURL = mainClass![MatchTopicInfo.pictureURL] as? String
		self.topic_id = mainClass![MatchTopicInfo.topic_id] as? String

		let answerArr = mainClass![MatchTopicInfo.answers] as? NSArray

		for answer in answerArr! {
			if let dict = answer as? NSDictionary {
				let contentStr = dict[MatchTopicInfo.content] as! String
				self.answers.append(contentStr)
			}
		}

		/*
		 if let bg = bgImage {
		 self.bgImage!.image = bg
		 }
		 */
	}
}

class MatchTopicFragment: UICollectionViewCell {
	var topicTitle: UILabel
	var topicDetail: UITextView
	var topicImage: UIImageView

	override init(frame: CGRect) {
		topicTitle = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height / 2 - 15))

		topicDetail = UITextView(frame: CGRect(x: 10, y: frame.height / 2 + 10, width: frame.width - 20, height: frame.height / 2 - 15))

		topicImage = UIImageView(frame: frame)
		topicImage.contentMode = UIViewContentMode.scaleAspectFit

		super.init(frame: frame)
		contentView.addSubview(topicTitle)
		contentView.addSubview(topicDetail)
		backgroundView?.addSubview(topicImage)
	}

	func setTopic(_ matchTopic: MatchTopic) {

		topicTitle.text = matchTopic.title
		topicDetail.text = matchTopic.subtitle
		// topicImage.image = matchTopic.bgImage
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
