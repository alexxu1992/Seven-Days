//
//  BookViewController.swift
//  IOSDemo2
//
//  Created by Xiang Wang on 11/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class BookViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	// UI
	var collectionView: UICollectionView!
	var backButton: BackButton!
	// Data
	var bookItems: [BookItem]!
	// Constants
	let cellIdentifier = "BookFragment"
	
	//TODO: Remove this sample data generator later
	static func getSampleBookItem() -> [BookItem]{
		let book = Book(type: .Book, id: "0", isMine: true, index: 0, title: "Book", chapters: [])
		let chapter = Chapter(type: .Chapter, id: "1", index: 0, title: "Chapter", articles: [], book: book)
		let article = Article(type: .Article, id: "1", index: 3, title: "Article", paragraphs: [], chapter: chapter)
		let paragragh = Paragraph(type: .Text, content: "Test", assetUrl: "")
		book.chapters.append(chapter)
		chapter.articles.append(article)
		article.paragraphs.append(paragragh)
		return [book, chapter, article]
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
		super.init(nibName: nil, bundle: nil)
	}
	
	convenience init(bookItems: [BookItem]) {
		self.init()
		self.bookItems = bookItems
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// TODO: Replace this hard code button size
		let buttonWidth = CGFloat(80)
		let buttonHeight = CGFloat(40)
		
		backButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 2 * buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "back", target: self, action: #selector(didTapBackButton))
		
		collectionView = BookCollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - buttonHeight))
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(BookFragment.self, forCellWithReuseIdentifier: cellIdentifier)
		
		self.view.addSubview(collectionView)
		self.view.addSubview(backButton)
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return bookItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BookFragment
		// Render data for this cell
		let bookItem = bookItems[indexPath.row]
		cell.updateWithItem(bookItem)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let item = bookItems[indexPath.row]
		let selectedCell = collectionView.cellForItem(at: indexPath) as! BookFragment
		switch item.type {
			case .Article:
			// TODO: Open the article detail view
			let article = item as! Article
			present(ParagraphViewController(article: article, isMine: article.chapter.book.isMine), animated: false, completion: nil)
			case .Book: break
			// TODO: ?
			case .Chapter: break
			// TODO: ?
		}
	}
	
	// MARK: - Button Callbacks
	func didTapBackButton(_ sender: UIButton) {
		dismiss(animated: false, completion: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
