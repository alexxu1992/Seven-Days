//
//  OnBoardTextInput.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 9/22/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class OnBoardTextInput: UIView {
    var textInputLabel: UILabel!
    var textInputField: UITextField!
    
    init(frame: CGRect, textInputName: String, defaultInput: String, isPassword: Bool) {
        super.init(frame: frame)
        
        textInputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height))
        textInputLabel.text = textInputName
        
        textInputField = UITextField(frame: CGRect(x: frame.width / 3, y: 0, width: frame.width * 2 / 3, height: frame.height))
        textInputField.borderStyle = UITextBorderStyle.roundedRect
        textInputField.backgroundColor = UIColor.lightGray
        textInputField.text = defaultInput
        textInputField.isSecureTextEntry = isPassword
        
        addSubview(textInputLabel)
        addSubview(textInputField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
