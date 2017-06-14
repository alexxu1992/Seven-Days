//
//  ParagraphFragment.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

// TODO: Uncompleted
open class ParagraphFragment: UICollectionViewCell, UITextViewDelegate {
	var contentText: UITextView?
	
	var isMine: Bool!
	var paragraph: Paragraph!
	
	var deleteButton: DeleteButton!
	
	func updateWithParagraph(_ paragraph: Paragraph, isMine: Bool) {
		self.paragraph = paragraph
		self.isMine = isMine
		
		switch paragraph.type {
		case .Text:
			contentText = UITextView(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.75, height: frame.size.height))
			self.contentText!.isEditable = isMine
			contentText?.text = paragraph.content
			contentText?.delegate = self
			contentView.addSubview(contentText!)
		case .Audio: break
		case .Video: break
		case .Image: break
		}
		
		if isMine {
			deleteButton = DeleteButton(frame: CGRect(x: frame.size.width * 0.8, y: frame.size.height / 4, width: frame.size.width * 0.15, height: frame.size.height / 2))
			contentView.addSubview(deleteButton)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	open func textViewDidEndEditing(_ textView: UITextView) {
		if textView === contentText {
			paragraph.content = textView.text
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
