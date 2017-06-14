//
//  BookCollectionViews.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit

class ParagraphCollectionView: UICollectionView {
	init(frame: CGRect) {
		let paragraphCollectionViewLayout = LeftAlignedCollectionViewFlowLayout()
		paragraphCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		paragraphCollectionViewLayout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.2)		
		super.init(frame: frame, collectionViewLayout: paragraphCollectionViewLayout)
		self.backgroundColor = UIColor.clear
		self.isUserInteractionEnabled = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class BookCollectionView: UICollectionView {
	init(frame: CGRect) {
		let bookCollectionViewLayout = LeftAlignedCollectionViewFlowLayout()
		bookCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		bookCollectionViewLayout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.2)
		super.init(frame: frame, collectionViewLayout: bookCollectionViewLayout)
		self.backgroundColor = UIColor.clear
		self.isUserInteractionEnabled = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
