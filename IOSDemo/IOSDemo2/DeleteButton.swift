//
//  DeleteButton.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class DeleteButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("Delete", for: UIControlState())
        self.setTitleColor(UIColor.blue, for: UIControlState())
        self.backgroundColor = UIColor.red
    }
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
