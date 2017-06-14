//
//  MatchUserViewController.swift
//  IOSDemo2
//
//  Created by Chi Yang on 10/17/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class MatchUserViewController: UIViewController, MatchTopicFragmentDataSourceDelegate {

    var userCard:NSDictionary?
    var dataSource: MatchTopicFragmentDataSource?

    var findMoreButton: UIButton?
    var engageButton: UIButton?
    var userName:UILabel?
    var gender: UILabel?
    var avatar: UIImageView?
    var occupation: UILabel?
    var email: UILabel?
    var educations: UILabel?
    var tags: UILabel?
    var dismissBtn: UIButton?

    let titleLabelTopPadding:CGFloat = 40.0
    let titleLabelLeftPadding:CGFloat = 30.0
    let optionButtonMargin:CGFloat = 40.0

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = DataSourceStore.matchTopicFragmentDataSource
        dataSource!.delegate = self

        constructUserInfo()
        if dataSource?.findMoreCount < 5 {
            constructFindMoreButton()
        }
        constructDismissButton()
        constructEngageButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func constructDismissButton(){
        let frame = self.view.frame
        dismissBtn = UIButton(frame: CGRect(x: frame.width - 40, y: 5, width: 40, height: 40))
        dismissBtn?.setTitle("X", for: UIControlState())
        dismissBtn?.backgroundColor = UIColor.darkGray
        dismissBtn?.setTitleColor(UIColor.white, for: UIControlState())
        dismissBtn?.addTarget(self, action: #selector(dismissView), for: .touchUpInside)

        self.view.addSubview(dismissBtn!)
    }
    
    func constructUserInfo(){
        userName = UILabel(frame: CGRect(x: 10, y: 10, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        gender = UILabel(frame: CGRect(x: 10, y: 60, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        occupation = UILabel(frame: CGRect(x: 10, y: 100, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        email = UILabel(frame: CGRect(x: 10, y: 140, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        educations = UILabel(frame: CGRect(x: 10, y: 200, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        tags = UILabel(frame: CGRect(x: 10, y: 240, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))

        // TODO: need to pass the right value education is a array
        let name = userCard?.value(forKey: UserCardInfo.username) as! String
        //let genderStr = userCard?.valueForKey(UserCardInfo.gender) as! String
        //let occupationStr = userCard?.valueForKey(UserCardInfo.occupations) as! String
        let emailStr = userCard?.value(forKey: UserCardInfo.email) as! String
        //let educationsStr = userCard?.valueForKey(UserCardInfo.username) as! String
        //let tagsStr = userCard?.valueForKey(UserCardInfo.username) as! String

        userName?.text = name
        //gender?.text = genderStr
        //occupation?.text = occupationStr
        email?.text = emailStr
        //educations?.text = educationsStr
        //tags?.text = tagsStr

        self.view.addSubview(userName!)
        self.view.addSubview(gender!)
        self.view.addSubview(occupation!)
        self.view.addSubview(email!)
        self.view.addSubview(educations!)
        self.view.addSubview(tags!)
        
    }

    func constructFindMoreButton() {
        findMoreButton = UIButton(frame: CGRect(x: optionButtonMargin + 80, y: 300, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        
        findMoreButton?.setTitleColor(UIColor.black, for: UIControlState())
        findMoreButton?.setTitle("Find More", for: UIControlState())
        findMoreButton?.addTarget(self, action: #selector(findMorePressed), for: .touchUpInside)
        self.view.addSubview(findMoreButton!)
    }

    func constructEngageButton() {
        engageButton = UIButton(frame: CGRect(x: optionButtonMargin + 80, y: 380, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        engageButton?.setTitleColor(UIColor.black, for: UIControlState())
        engageButton?.setTitle("Add to Engage", for: UIControlState())
        engageButton?.addTarget(self, action: #selector(engagePressed), for: .touchUpInside)
        self.view.addSubview(engageButton!)
    }

    @IBAction func findMorePressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        print("Button \(button.titleLabel?.text) was pressed!")
        dataSource!.findMore()
    }

    @IBAction func engagePressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        print("Button \(button.titleLabel?.text) was pressed!")
        dataSource!.engageUser(userCard?.value(forKey: UserCardInfo.id) as! String)
    }

    func goToFindMorePage(_ userCard: NSDictionary) {
        let findMoreUserViewController = MatchUserViewController()
        findMoreUserViewController.userCard = userCard
        self.present(findMoreUserViewController, animated: false, completion: nil)
    }

    /** Show Alert when try to engage user but failed*/
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func dismissView() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
