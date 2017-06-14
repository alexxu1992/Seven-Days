//
//  ConfirmButton.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/29/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class UploadButton: UIButton {
    init(frame: CGRect, buttonTitle: String, target: UIViewController, action: Selector) {
        super.init(frame: frame)
        self.setTitle(buttonTitle, for: UIControlState())
        self.setTitleColor(UIColor.blue, for: UIControlState())
        self.addTarget(target, action: action, for: .touchUpInside)
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
