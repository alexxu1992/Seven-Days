//
//  LastingMainViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class LastingMainViewController:  UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NameCardFragmentDataSourceDelegate {
    var searchBar: UISearchBar!
    var collectionView: HostCollectionView!
    var engageList: NSArray = []
    var dataSource: NameCardFragmentDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar(frame: CGRect(x: 10, y: 40, width: self.view.frame.width - 20, height: 30))
        
        dataSource = DataSourceStore.nameCardFragmentDataSource
        
        dataSource!.delegate = self
        
        engageList = dataSource!.engageList
        
        collectionView = HostCollectionView(frame: CGRect(x: 10, y: 70, width: self.view.frame.width, height: self.view.frame.height - 40))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.register(NameCardFragment.self, forCellWithReuseIdentifier: "NameCardFragment")
        
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.navigationController?.title = "Lasting"
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
            
            let milliseconds = engageListItem[EngageListInfo.millisecondsLeft] as! NSNumber
            let timeDic = convertMilliseconds(milliseconds.intValue, day: true,
                                              hour: true, minute: true, second: true)
            cell.showTimeLeftLabel(convertTimeDic(timeDic, typeNumber: 2))
        }
        
        return cell
    }
    
    // MARK: - NameCardFragmentDataSourceDelegate
    func reloadData() {
        self.collectionView.reloadData()
    }
}
