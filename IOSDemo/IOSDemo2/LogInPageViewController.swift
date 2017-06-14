//
//  LogInPageViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 9/19/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

class LogInPageViewController: UIViewController {
    var emailInput: OnBoardTextInput!
    var passwordInput: OnBoardTextInput!
    var signUpbutton: OnBoardButton!
    var loginButton: OnBoardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput = OnBoardTextInput(frame: CGRect(x: 80, y: 200, width: 250, height: 30), textInputName: "Email", defaultInput: "0@nanguo.com", isPassword: false)
        passwordInput = OnBoardTextInput(frame: CGRect(x: 80, y: 240, width: 250, height: 30), textInputName: "Password", defaultInput: "123456", isPassword: true)
        
        signUpbutton = OnBoardButton(frame: CGRect(x: 80, y: 300, width: 100, height: 30), buttonTitle: "Sign Up", target: self, action: #selector(didTapSignUpButton))
        loginButton = OnBoardButton(frame: CGRect(x: 230, y: 300, width: 100, height: 30), buttonTitle: "Login", target: self, action: #selector(didTapLogInButton))
        
        self.view.addSubview(emailInput)
        self.view.addSubview(passwordInput)
        self.view.addSubview(signUpbutton)
        self.view.addSubview(loginButton)
    }
    
    //MARK: Actions
    func didTapLogInButton(_ sender: UIButton) {
        if let email = emailInput.textInputField.text, let password = passwordInput.textInputField.text{
            let loginObject = OnBoardDataObject(email: email, password: password)
            DataSourceStore.onBoardDataSource.login(loginObject, completionHandler: { (error) in
                if error != "" {
                    let alertController = UIAlertController(title: COMMON.ERROR, message: error, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: COMMON.OK, style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: false, completion: nil)
                } else {
					let rootViewController = RootViewController()
					self.present(rootViewController, animated: false, completion: nil)
                }
            })
        }
    }
    
    func didTapSignUpButton(_ sender: UIButton) {
        present(SignUpPageViewController(), animated: false, completion: nil)
    }
    
    //MARK: Load DataSourceStore
    //TODO: the logic of loadDataSourceStore() need to be optimized. We need to wait all three async. func to complete then enter the matchDirection.

    func loadDataSourceStore() {

        DataSourceStore.nameCardFragmentDataSource.loadNameCardListData(){}
        DataSourceStore.meDataSource.loadUserInformation(){}

        DataSourceStore.matchTopicFragmentDataSource.loadMatchTopic {
            let rootViewController = RootViewController()
            self.present(rootViewController, animated: false, completion: nil)
        }
    }
}
