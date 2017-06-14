//
//  MeEditProfileViewController.swift
//  IOSDemo2
//
//  Created by 陈科宇 on 16/10/7.
//  Copyright © 2016年 Nan Guo. All rights reserved.
//

import UIKit

class MeEditProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var backToMeButton: BackButton!
    var confirmButton: ConfirmButton!
    var nameInput: OnBoardTextInput!
    var ageInput: OnBoardTextInput!
    var collegeInput: OnBoardTextInput!
    var occupationInput: OnBoardTextInput!
    var avatarLabel: UILabel?
    var avatar: AvatarButton!
    var imagePicker = UIImagePickerController()
    var tmpAvatar = UIImage(data: avatarData!)
    
    var dataSource: MeDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataSourceStore.meDataSource
        
        backToMeButton = BackButton(frame: CGRect(x: SCREEN_WIDTH/10, y: SCREEN_HEIGHT * 0.8, width: 80, height: 40), buttonTitle: "back", target: self, action: #selector(didTapBackToMeButton))
        confirmButton = ConfirmButton(frame: CGRect(x: SCREEN_WIDTH * 0.7, y: SCREEN_HEIGHT * 0.8, width: 80, height: 40), buttonTitle: "confirm", target: self, action: #selector(didTapConfirmButton))
        nameInput = OnBoardTextInput(frame: CGRect(x: 10, y: SCREEN_HEIGHT * 0.4, width: SCREEN_WIDTH * 0.9, height: 40), textInputName: "姓名", defaultInput: dataSource!.userInfoItem.username, isPassword: false)
        ageInput = OnBoardTextInput(frame: CGRect(x: 10, y: SCREEN_HEIGHT * 0.4 + 50, width: SCREEN_WIDTH * 0.9, height: 40), textInputName: "年龄", defaultInput: dataSource!.userInfoItem.age, isPassword: false)
        collegeInput = OnBoardTextInput(frame: CGRect(x: 10, y: SCREEN_HEIGHT * 0.4 + 100, width: SCREEN_WIDTH * 0.9, height: 40), textInputName: "毕业院校", defaultInput: dataSource!.userInfoItem.college, isPassword: false)
        occupationInput = OnBoardTextInput(frame: CGRect(x: 10, y: SCREEN_HEIGHT * 0.4 + 150, width: SCREEN_WIDTH * 0.9, height: 40), textInputName: "从事工作", defaultInput: dataSource!.userInfoItem.occupation, isPassword: false)
        avatarLabel = UILabel(frame: CGRect(x: 10,y: 20,width: 40,height: 40))
        avatarLabel?.text = "头像"
        avatar = AvatarButton(frame: CGRect(x: 10, y: 70, width: SCREEN_HEIGHT/5, height: SCREEN_HEIGHT/5), buttonTitle: "", target: self, action: #selector(chooseAvatar))
        avatar.setImage(UIImage(data: avatarData), for: UIControlState())
        
        self.view.addSubview(backToMeButton)
        self.view.addSubview(confirmButton)
        self.view.addSubview(nameInput)
        self.view.addSubview(ageInput)
        self.view.addSubview(collegeInput)
        self.view.addSubview(occupationInput)
        self.view.addSubview(avatarLabel!)
        self.view.addSubview(avatar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapBackToMeButton(_ sender: UIButton){
        //presentViewController(MeMainViewController(), animated: false, completion: nil)
        dismiss(animated: false, completion: nil)
    }
    
    func didTapConfirmButton(_ sender: UIButton){
        dataSource!.userInfoItem.username = nameInput.textInputField.text!
        dataSource!.userInfoItem.age = ageInput.textInputField.text!
        dataSource!.userInfoItem.college = collegeInput.textInputField.text!
        dataSource!.userInfoItem.occupation = occupationInput.textInputField.text!
        avatarData = UIImagePNGRepresentation(tmpAvatar!)
        dataSource?.uploadUserInformation()
        dataSource?.uploadAvatar()
    }
    func chooseAvatar(_ sender: UIButton){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: false, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: false, completion: nil)

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let selectedImage = info[UIImagePickerControllerOriginalImage]as! UIImage!
        tmpAvatar = selectedImage
        avatar.setImage(tmpAvatar, for: UIControlState())
        dismiss(animated: false, completion: nil)

    }
    
}
