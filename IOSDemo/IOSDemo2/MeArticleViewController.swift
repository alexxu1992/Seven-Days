//
//  MeArticleViewController.swift
//  IOSDemo2
//
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import UIKit

class MeArticleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MeDataSourceDelegate, ItemViewControllerDelegate {
	
	var collectionView: UICollectionView!
	var backToMeButton: BackButton!
	var addNewButton: AddNewButton!
	
	var selectedArticleItem_Deprecated: ArticleItem_Deprecated!
	var articleItems: [ArticleItem_Deprecated] = []
	let cellIdentifier = "ArticleFragment_Deprecated"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let buttonWidth = CGFloat(80)
		let buttonHeight = CGFloat(40)
		
		backToMeButton = BackButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Back", target: self, action: #selector(didTapBackToMeButton))
		addNewButton = AddNewButton(frame: CGRect(x: buttonWidth * 1.1, y: SCREEN_HEIGHT - buttonHeight, width: buttonWidth, height: buttonHeight), buttonTitle: "Add New", target: self, action: #selector(didTapAddNewButton))
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.2)
		collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - buttonHeight) , collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(ArticleFragment_Deprecated.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionView.backgroundColor = UIColor.clear
		
		self.view.addSubview(collectionView)
		self.view.addSubview(backToMeButton)
		self.view.addSubview(addNewButton)

		articleItems += loadArticleItem_Deprecateds()
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return articleItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ArticleFragment_Deprecated
		// Render data for this cell
		let articleItem = articleItems[indexPath.row]
		// TODO: Find a better render way of the local or server data information and put all these configuration code inside updateWithItem function
		cell.articleTitleLabel.text = articleItem.articleTitle + (articleItem.id == "" ? "-local" : "-server")
		cell.deleteButton.addTarget(self, action: #selector(deleteArticleItem_Deprecated), for: .touchUpInside)
		cell.index = indexPath.row
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedArticleItem_Deprecated = articleItems[indexPath.row]
		presentDetailView()
	}
	
	// MARK: - NSCoding
	func saveArticleItem_Deprecateds() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(articleItems, toFile: ArticleItem_Deprecated.CACHE_URL.path)
		if !isSuccessfulSave {
			print("Failed to save article items")
		}
	}

	func loadArticleItem_Deprecateds() -> [ArticleItem_Deprecated] {
		var items: [ArticleItem_Deprecated] = []
		var ids = Set<String>()
		if let savedItems = NSKeyedUnarchiver.unarchiveObject(withFile: ArticleItem_Deprecated.CACHE_URL.path) as?[ArticleItem_Deprecated] {
			for item in savedItems {
				if item.id != "" {
					ids.insert(item.id)
				}
			}
			items = savedItems
		}
		let uploadedItems = DataSourceStore.meDataSource.nameCards[NameCardInfo.articles] as! [[String : AnyObject]]
		for article in uploadedItems {
			if !ids.contains(article[ArticleInfo.id] as! String) {
				let item = ArticleItem_Deprecated(articleTitle: article[ArticleInfo.title] as! String, articleBody: article[ArticleInfo.content] as! String, id: article[ArticleInfo.id] as! String)
				items.append(item!)
			}
		}
		return items
	}
	
	// MARK: - Helper Functions
	func presentDetailView() {
		let articleDetailVC = ArticleDetailViewController(articleItem: selectedArticleItem_Deprecated, delegate: self, editable: true)
		present(articleDetailVC, animated: false, completion: nil)
	}
	
	
	func deleteArticleItem_Deprecated (_ sender: AnyObject) {
		let alertController = UIAlertController(title: "Sure to delete?", message: "The article will be deleted yo!", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "YES!", style: .default, handler: {(action: UIAlertAction) in
			let button = sender as! DeleteButton
			let cell = button.superview?.superview as! ArticleFragment_Deprecated
			if let item = self.selectedArticleItem_Deprecated, item == self.articleItems[cell.index] {
				
			}
			self.articleItems.remove(at: cell.index)
			self.saveArticleItem_Deprecateds()
			self.reloadData()
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in
			alertController.dismiss(animated: false, completion: nil)
		}))
		present(alertController, animated:true, completion: nil)
	}
	
	
	// MARK: - Button Call Backs
	func didTapBackToMeButton(_ sender: UIButton){
		dismiss(animated: false, completion: nil)
	}
	
	func didTapAddNewButton(_ sender: UIButton) {
		selectedArticleItem_Deprecated = ArticleItem_Deprecated(articleTitle: "New Title", articleBody: "", id: "")
		presentDetailView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Data Source Delegate Methods
	func reloadData() {
		self.collectionView.reloadData()
	}
	
	// MARK: - ItemViewControllerDelegate Methods
	func saveItems () {
		var exist:Bool = false
		for item in articleItems {
			if item == selectedArticleItem_Deprecated {
				exist = true
			}
		}
		if !exist {
			articleItems.append(selectedArticleItem_Deprecated)
		}
		self.reloadData()
		saveArticleItem_Deprecateds()
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
}
