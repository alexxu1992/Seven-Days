//
//  ParagraphViewController.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class ParagraphViewController: UIViewController, UICollectionViewDataSource {
	// UI
	var collectionView: UICollectionView!
	var backButton: BackButton!
	var addNewTextButton: AddNewButton!
	// Data
	var article: Article!
	var isMine: Bool!
	// Constants
	let cellIdentifier = "ParagraphFragment"
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
		super.init(nibName: nil, bundle: nil)
	}
	
	convenience init(article: Article, isMine: Bool) {
		self.init()
		self.article = article
		self.isMine = isMine
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// TODO: Replace this hard code button size
		let buttonWidth = CGFloat(80)
		let buttonHeight = CGFloat(40)
		
		backButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 2 * buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "back", target: self, action: #selector(didTapBackButton))
		
		collectionView = ParagraphCollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - buttonHeight))
		collectionView.dataSource = self
		collectionView.register(ParagraphFragment.self, forCellWithReuseIdentifier: cellIdentifier)
		
		self.view.addSubview(collectionView)
		self.view.addSubview(backButton)
		
		if isMine! {
			addNewTextButton = AddNewButton(frame: CGRect(x: buttonWidth * 1.1, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Add Text", target: self, action: #selector(didTapAddNewTextButton))
			self.view.addSubview(addNewTextButton)
		}
		
		self.hideKeyboardWhenTappedAround()
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return article.paragraphs.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ParagraphFragment
		// Render data for this cell
		let paragraph = article.paragraphs[indexPath.row]
		cell.updateWithParagraph(paragraph, isMine: isMine)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
		let item = article.paragraphs[indexPath.row]
		let selectedCell = collectionView.cellForItem(at: indexPath) as! ParagraphFragment
		switch item.type {
			case .Audio: break
			// TODO: Play the audio
			case .Image: break
			// TODO: ?
			case .Text: break
			// TODO: ?
			case .Video: break
		}
	}
	
	// MARK: - Button Callbacks
	func didTapBackButton(_ sender: UIButton) {
		dismiss(animated: false, completion: nil)
	}
	
	func didTapAddNewTextButton(_ sender: UIButton) {
		article.paragraphs.append(Paragraph(type: .Text, content: "", assetUrl: ""))
		self.reloadData()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Data Source Delegate Methods
	func reloadData() {
		self.collectionView.reloadData()
	}
}
