//
//  EngageMainViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class EngageMainViewController:  UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NameCardFragmentDataSourceDelegate {
    
    var collectionView: HostCollectionView!
    var engageList: NSArray = []
    var dataSource: NameCardFragmentDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        dataSource = DataSourceStore.nameCardFragmentDataSource
        
        dataSource!.delegate = self
        
        engageList = dataSource!.engageList
        
        collectionView = HostCollectionView(frame: self.view.frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.register(NameCardFragment.self, forCellWithReuseIdentifier: "NameCardFragment")
        
        self.view.addSubview(collectionView)
        
        self.navigationController?.title = "Engage"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return engageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCardFragment", for: indexPath) as! NameCardFragment
        
        if let engageListItem = engageList[indexPath.row] as? NSDictionary {
            if let userCard = engageListItem[EngageListInfo.userCard] as? NSDictionary {
                cell.nameLabel.text = String(describing: userCard[UserCardInfo.username])
            }
            if let lastMessage = engageListItem[EngageListInfo.lastMessage] {
                cell.lastMessageText.text = lastMessage as! String
            }
            else {
                cell.lastMessageText.text = ERROR.NO_MESSAGE
            }
            
            cell.iconImageView.image = UIImage(named: "test")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let engageListItem = engageList[indexPath.row] as? NSDictionary, let userCard = engageListItem[EngageListInfo.userCard] as? NSDictionary else {
            print("Function: \(#function), line: \(#line): parsing engageList user failed")
            return
        }

        let messageViewController = MessageViewController()
        messageViewController.initUser(userCard)
        present(messageViewController, animated: true, completion: nil)
    }

    // MARK: - NameCardFragmentDataSourceDelegate
    func reloadData() {
        self.collectionView.reloadData()
    }
}
