//
//  SignUpPageViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 9/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit
class SignUpPageViewController: UIViewController, UITextFieldDelegate {
    var emailInput: OnBoardTextInput!
    var passwordInput: OnBoardTextInput!
    var nameInput: OnBoardTextInput!
    var genderInput: OnBoardTextInput!
    var loginButton: OnBoardButton!
    var submitButton: OnBoardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput = OnBoardTextInput(frame: CGRect(x: 80, y: 200, width: 250, height: 30), textInputName: "Email", defaultInput: "", isPassword: false)
        passwordInput = OnBoardTextInput(frame: CGRect(x: 80, y: 240, width: 250, height: 30), textInputName: "Password", defaultInput: "", isPassword: true)
        nameInput = OnBoardTextInput(frame: CGRect(x: 80, y: 280, width: 250, height: 30), textInputName: "Name", defaultInput: "", isPassword: false)
        genderInput = OnBoardTextInput(frame: CGRect(x: 80, y: 320, width: 250, height: 30), textInputName: "Gender", defaultInput: "", isPassword: false)
        
        submitButton = OnBoardButton(frame: CGRect(x: 80, y: 370, width: 100, height: 30), buttonTitle: "Submit", target: self, action: #selector(didTapSubmitButton))
        loginButton = OnBoardButton(frame: CGRect(x: 230, y: 370, width: 100, height: 30), buttonTitle: "Login", target: self, action: #selector(didTapLogInButton))
        
        self.view.addSubview(emailInput)
        self.view.addSubview(passwordInput)
        self.view.addSubview(nameInput)
        self.view.addSubview(genderInput)
        self.view.addSubview(submitButton)
        self.view.addSubview(loginButton)
    }

    //MARK: Actions
    func didTapSubmitButton(_ sender: UIButton) {
        if let email = emailInput.textInputField.text, let password = passwordInput.textInputField.text, let name = nameInput.textInputField.text, let gender = genderInput.textInputField.text {
            
            let signUpObject = OnBoardDataObject (email: email, password: password, username: name, gender: gender)
            DataSourceStore.onBoardDataSource.signUp(signUpObject, completionHandler: { (error) in
                if error != "" {
                    self.showErrorAlert(error)
                } else {
                   print("Sign Up Success")
                }
            })
        }
    }
    
    func didTapLogInButton(_ sender: UIButton) {
        present(SignUpPageViewController(), animated: false, completion: nil)
    }
    
    func showErrorAlert(_ err: String) {
        if err == "" {
            return
        }
        let alertController = UIAlertController(title: COMMON.ERROR, message: err, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: COMMON.OK, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: false, completion: nil)
    }
    
    // MARK: UITextFieldDelegate Methods
    // TODO: definitely can use a niter logic here and save lines of code
    func textFieldDidEndEditing(_ textField: UITextField) {
        var errMsg: String? = nil
        if textField == emailInput.textInputField, let email = emailInput.textInputField.text {
            let checkEmailDataObject = OnBoardDataObject(email: email, password: nil, username: nil, gender: nil)
            DataSourceStore.onBoardDataSource.checkServerErrorForDataObject(checkEmailDataObject, apiRelativeURL: "/api/users/unused_email/", completionHandler: { (error) in
                if error != "" {
                    self.showErrorAlert(error)
                }
            })
        } else if textField == passwordInput.textInputField, let password = passwordInput.textInputField.text {
            let checkPasswordDataObject = OnBoardDataObject(email: nil, password: password, username: nil, gender: nil)
            if let err = checkPasswordDataObject.checkInputError() {
                errMsg = err
            }
            
        } else if textField == nameInput.textInputField, let name = nameInput.textInputField.text {
            let checkUsernameDataObject = OnBoardDataObject(email: nil, password: nil, username: name, gender: nil)
            DataSourceStore.onBoardDataSource.checkServerErrorForDataObject(checkUsernameDataObject, apiRelativeURL: "/api/users/unused_username/", completionHandler: { (error) in
                if error != "" {
                    self.showErrorAlert(error)
                }
            })
            
        } else if textField == genderInput.textInputField, let gender = genderInput.textInputField.text {
            let checkGenderDataObject = OnBoardDataObject(email: nil, password: nil, username: nil, gender: gender)
            if let err = checkGenderDataObject.checkInputError() {
                errMsg = err
            }
        }
        if errMsg != nil {
            self.showErrorAlert(errMsg!)
        }
    }
}
