//
//  HostCollectionView.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class HostCollectionView: UICollectionView {
    
    init(frame: CGRect) {
        let hostCollectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        
        hostCollectionViewLayout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        hostCollectionViewLayout.itemSize = CGSize(width: 200, height: 120)
        
        super.init(frame: frame, collectionViewLayout: hostCollectionViewLayout)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
