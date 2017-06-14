//
//  MatchMainViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class MatchMainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MatchTopicFragmentDataSourceDelegate {
    
    var collectionView:  HostCollectionView!
    var matchTopicList: Array<MatchTopic> = []
    var dataSource: MatchTopicFragmentDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataSourceStore.matchTopicFragmentDataSource
        matchTopicList = dataSource!.thedatesTopic
        dataSource!.delegate = self
        
        collectionView = HostCollectionView(frame: self.view.frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.register(MatchTopicFragment.self, forCellWithReuseIdentifier: "matchTopicFragment")
        
        self.view.addSubview(collectionView)
        
        self.navigationController?.title = "Match"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchTopicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchTopicFragment", for: indexPath) as! MatchTopicFragment
        
        let matchTopic = matchTopicList[indexPath.row] as MatchTopic
        cell.setTopic(matchTopic)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchTopic = matchTopicList[indexPath.row] as MatchTopic
        let topicViewController = MatchTopicViewController()
        topicViewController.aTopic = matchTopic
        self.present(topicViewController, animated: false, completion: nil)
    }
    // MARK: - NameCardFragmentDataSourceDelegate
    func reloadData() {
        self.collectionView.reloadData()
    }
}
