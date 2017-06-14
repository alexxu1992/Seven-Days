//
//  ArticleTextInput.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/15/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

protocol ItemViewControllerDelegate: class {
	func saveItems()
}

class ArticleDetailViewController: UIViewController {
	var articleTitleField: UITextField!
	var articleBodyField: UITextField!
	var backToMeButton: BackButton!
	var saveButton: ConfirmButton?
	
	var articleItem: ArticleItem_Deprecated!
	var delegate: ItemViewControllerDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(articleTitleField)
		self.view.addSubview(articleBodyField)
		self.view.addSubview(backToMeButton)
		if let saveBtn = saveButton {
			self.view.addSubview(saveBtn)
		}
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	convenience init(articleItem: ArticleItem_Deprecated, delegate: ItemViewControllerDelegate, editable: Bool) {
		self.init(nibName:nil, bundle:nil)
		self.articleItem = articleItem
		self.delegate = delegate
		let buttonWidth = CGFloat(80)
		let buttonHeight = CGFloat(40)
		articleTitleField = UITextField(frame: CGRect(x: 0, y: 30, width: SCREEN_WIDTH, height: 30))
		articleTitleField.text = articleItem.articleTitle
		articleTitleField.isEnabled = editable
		
		articleBodyField = UITextField(frame: CGRect(x: 0, y: 60, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 30))
		articleBodyField.borderStyle = UITextBorderStyle.roundedRect
		articleBodyField.backgroundColor = UIColor.lightGray
		articleBodyField.text = articleItem.articleBody
		articleBodyField.contentVerticalAlignment = UIControlContentVerticalAlignment.top
		articleBodyField.isEnabled = editable
		
		backToMeButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "back", target: self, action: #selector(didTapBackToMeButton))
		if (editable) {
			saveButton = ConfirmButton(frame: CGRect(x: buttonWidth * 1.1, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "save", target: self, action: #selector(didTapSaveButton))
		}
	}
	
	// MARK: - Button Call Backs
	func didTapBackToMeButton(_ sender: UIButton){
		dismiss(animated: true, completion: nil)
	}
	
	func didTapSaveButton(_ sender: UIButton){
		if let title = articleTitleField.text {
			articleItem.articleTitle = title
			if let body = articleBodyField.text {
				articleItem.articleBody = body
			}
			delegate.saveItems()
		} else {
			let alertController = UIAlertController(title: "Error", message: "Titile should not be empty!", preferredStyle: .alert)
			present(alertController, animated:true, completion: nil)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
