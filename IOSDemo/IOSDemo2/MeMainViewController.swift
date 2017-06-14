//
//  MeMainViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class MeMainViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MeDataSourceDelegate {
	var collectionView: UICollectionView!
	var LogoutButton: OnBoardButton!
	var avatar: OnBoardButton!
	var userInfoItem: UserInfoItem!
	var dataSource: MeDataSource?
	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = DataSourceStore.meDataSource;
		dataSource!.delegate = self
		userInfoItem = dataSource!.userInfoItem
		
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
		layout.itemSize = CGSize(width: SCREEN_WIDTH * 0.25, height: SCREEN_WIDTH * 0.25)
		
		avatarData = try? Data(contentsOf: URL(string: dataSource!.userInfoItem.avatar)!)
		collectionView = UICollectionView(frame: CGRect(x: 0, y: SCREEN_HEIGHT * 0.36, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.5) , collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(MeCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.backgroundColor = UIColor.clear
		
		self.navigationController?.title = "Me"
		
		LogoutButton = OnBoardButton(frame: CGRect(x: SCREEN_WIDTH * 0.5 - 50, y: SCREEN_HEIGHT * 0.9 - 30, width: 100, height: 30), buttonTitle: "Logout", target: self, action: #selector(didTapLogoutButton))
		
		avatar = OnBoardButton(frame: CGRect(x: SCREEN_WIDTH * 0.5-50, y: SCREEN_HEIGHT * 0.1, width: 100, height: 100), buttonTitle: "", target: self, action: #selector(didTapProfileEditButton))
		avatar.setImage(UIImage(data: avatarData), for: UIControlState())
		avatar.backgroundColor = UIColor.clear
		
		self.view.addSubview(collectionView)
		self.view.addSubview(LogoutButton)
		self.view.addSubview(avatar)
	}
	
	// MARK: - Button Call Backs
	func didTapProfileEditButton(_ sender: UIButton){
		present(MeEditProfileViewController(), animated: false, completion: nil)
	}
	
	func didTapLogoutButton(_ sender: UIButton) {
		present(LogInPageViewController(), animated: false, completion: nil)
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MeCell
		cell.backgroundColor = UIColor.clear
		switch indexPath.row {
		case 0:
			cell.cellImage.image = UIImage(named: "article")
		case 1:
			cell.cellImage.image = UIImage(named: "music")
		case 2:
			cell.cellImage.image = UIImage(named: "photo")
		case 3:
			cell.cellImage.image = UIImage(named: "movie")
		default:
			cell.cellImage.image = UIImage(named: "add")
		}
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var nextView: UIViewController!
		print (indexPath.row)
		switch indexPath.row{
		case 0:
			nextView = MeArticleViewController()
		case 1:
			nextView = MeAudioViewController()
		case 2:
			nextView = MePhotoViewController()
		case 3:
			nextView = BookViewController(bookItems: BookViewController.getSampleBookItem())
		default:
			return
		}
		present(nextView, animated: false, completion: nil)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		avatar.setImage(UIImage(data: avatarData), for: UIControlState())
	}
	// MARK: - MeDataSourceDelegate
	func reloadData() {
		self.collectionView.reloadData()
	}
}
