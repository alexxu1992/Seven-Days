//
//  AddUrlView.swift
//  IOSDemo2
//
//  Created by 陈科宇 on 16/10/31.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class AddUrlView: UIView {
    var addUrlTextField: UITextField!
    var backButton: UIButton!
    var confirmButton: UIButton!
    init(frame: CGRect, targetForBack: UIViewController,targetForConfirm: UIViewController, actionForBack: Selector, actionForConfirm: Selector) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addUrlTextField = UITextField(frame: CGRect(x: frame.width * 0.2, y: frame.height * 0.4, width: frame.width * 0.5, height: 40))
        addUrlTextField.placeholder = "Input your url"
        addUrlTextField.backgroundColor = UIColor.lightGray
        
        backButton = UIButton(frame: CGRect(x: frame.width * 0.2, y: frame.height * 0.9, width: 80, height: 40))
        backButton.setTitle("Back", for: UIControlState())
        backButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        backButton.addTarget(targetForBack, action: actionForBack, for: .touchUpInside)
        
        
        confirmButton = UIButton(frame: CGRect(x: frame.width * 0.6, y: frame.height * 0.9, width: 80, height: 40))
        confirmButton.setTitle("Confirm", for: UIControlState())
        confirmButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        confirmButton.addTarget(targetForConfirm, action: actionForConfirm, for: .touchUpInside)
        
        
        addSubview(addUrlTextField)
        addSubview(backButton)
        addSubview(confirmButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
