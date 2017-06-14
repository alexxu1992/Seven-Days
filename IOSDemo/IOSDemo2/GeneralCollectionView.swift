//
//  GeneralNameCardView.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 11/12/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

// TODO: Uncompleted
class NameCardViewConfiguration {
	var frame: CGRect!
	var targetForBack: UIViewController!
	var actionForBack: Selector!
	var fragmentType: AnyClass!
	var cellIdentifier: String!
	var items: [Item] = []
	
	func checkForValidity() -> Bool {
		if frame == nil || targetForBack == nil || actionForBack == nil
			|| fragmentType == nil || cellIdentifier == nil {
			return false
		}
		return true
	}
}

// TODO: Uncompleted
class GeneralNameCardView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var collectionView: UICollectionView!
	var backButton: BackButton!
	var articleTextView: UIView!
	
	var selectedArticleItem_Deprecated: ArticleItem_Deprecated!
	var items: [Item] = []
	var cellIdentifier: String!
	
	init(configuration: NameCardViewConfiguration) throws {
		if !configuration.checkForValidity() {
			throw ThrowableError.illegalArgument("The collection configuration is not complete")
		} else {
			super.init(frame: configuration.frame)
			self.cellIdentifier = configuration.cellIdentifier
			self.items = configuration.items
			let buttonWidth = CGFloat(80)
			let buttonHeight = CGFloat(40)
			
			backButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Back", target: configuration.targetForBack, action: configuration.actionForBack)
			let layout = UICollectionViewFlowLayout()
			layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
			layout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.2)
			collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - buttonHeight) , collectionViewLayout: layout)
			collectionView.dataSource = self
			collectionView.delegate = self
			collectionView.register(configuration.fragmentType, forCellWithReuseIdentifier: configuration.cellIdentifier)
			collectionView.backgroundColor = UIColor.clear
			addSubview(collectionView)
			addSubview(backButton)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AbstractFragment
		let item = items[indexPath.row]
		cell.updateWithItem(item, index: indexPath.row)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
}

