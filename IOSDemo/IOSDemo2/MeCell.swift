//
//  MeCell.swift
//  IOSDemo2
//
//  Created by 陈科宇 on 16/10/6.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import UIKit

class MeCell: UICollectionViewCell {
    var cellImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        cellImage.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(cellImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
