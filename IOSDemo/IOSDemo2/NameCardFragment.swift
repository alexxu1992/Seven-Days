//
//  NameCardFragment.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 9/16/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

open class NameCardFragment: UICollectionViewCell {
    var iconImageView: UIImageView //TODO: extend to PhotoViewController
    var nameLabel: UILabel
    var lastMessageText: UITextView //TODO: extend to a subclass of MessageViewController
    var timeLeftLabel: UILabel
    
    override init(frame: CGRect) {
       
        
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height))
        iconImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.width, y: 0, width: frame.width * 2 / 3, height: frame.height / 3))
        nameLabel.textAlignment = .center
        
        lastMessageText = UITextView(frame: CGRect(x: iconImageView.frame.width, y: frame.height / 3, width: frame.width * 2 / 3, height: frame.height * 2 / 3))
        timeLeftLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastMessageText)
    }
    
    func showTimeLeftLabel(_ timeLeft: String) {
        timeLeftLabel.text = timeLeft
        contentView.addSubview(timeLeftLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
