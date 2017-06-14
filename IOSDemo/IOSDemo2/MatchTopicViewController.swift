//
//  MatchTopicViewController.swift
//  IOSDemo2
//
//  Created by Chi Yang on 10/7/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit

class MatchTopicViewController: UIViewController, MatchTopicFragmentDataSourceDelegate {

    var aTopic: MatchTopic?
    var dataSource: MatchTopicFragmentDataSource?

    var topicTitle: UILabel?
    var topicSubtitle: UILabel?
    var topicDetail: UITextView?
    var topicImage: UIImageView?
    var optionA: UIButton?
    var optionB: UIButton?
    var optionC: UIButton?
    var optionD: UIButton?
    var optionButtons:[UIButton]?
    var goToMeetBtn: UIButton?
    var dismissBtn: UIButton?

    let titleLabelTopPadding:CGFloat = 40.0
    let titleLabelLeftPadding:CGFloat = 30.0
    let optionButtonMargin:CGFloat = 40.0
    var selectedIdx = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataSourceStore.matchTopicFragmentDataSource
        dataSource!.delegate = self

        self.navigationController?.title = "Match"

        constructUI()
        constructGoToMeetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func constructGoToMeetButton() {
        goToMeetBtn = UIButton(frame: CGRect(x: optionButtonMargin + 80, y: self.view.frame.height / 2 + 150, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        goToMeetBtn?.setTitleColor(UIColor.black, for: UIControlState())
        goToMeetBtn?.setTitle("Go To Meet", for: UIControlState())
        goToMeetBtn?.addTarget(self, action: #selector(goToMeetPressed), for: .touchUpInside)
        self.view.addSubview(goToMeetBtn!)
    }

    func constructUI() {
        let frame = self.view.frame
        topicTitle = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 30))
        topicTitle?.text = aTopic?.title
        topicTitle?.center.x = self.view.center.x

        topicSubtitle = UILabel(frame: CGRect(x: 10, y: 50, width: frame.width - 20, height: 30))
        topicSubtitle?.text = aTopic?.subtitle
        topicSubtitle?.center.x = self.view.center.x

        topicDetail = UITextView(frame: CGRect(x: 10, y: frame.height / 2 - 200, width: frame.width - 20, height: 120.0))
        topicDetail?.center.x = self.view.center.x
        topicDetail?.text = aTopic?.story
        topicDetail?.isUserInteractionEnabled = false

        topicImage = UIImageView(frame: frame)
        topicImage!.contentMode = UIViewContentMode.scaleAspectFit
        topicImage?.image = aTopic?.bgImage

        optionA = UIButton(frame: CGRect(x: optionButtonMargin, y: frame.height / 2 - 50, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        optionB = UIButton(frame: CGRect(x: optionButtonMargin, y: frame.height / 2, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        optionC = UIButton(frame: CGRect(x: optionButtonMargin, y: frame.height / 2 + 50, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))
        optionD = UIButton(frame: CGRect(x: optionButtonMargin, y: frame.height / 2 + 100, width: self.view.bounds.width - 2 * titleLabelLeftPadding, height: 50))

        optionButtons = [optionA!, optionB!, optionC!, optionD!]


        for (index, answer) in aTopic!.answers.enumerated() {
            let button = optionButtons![index]
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.tag = index
            button.addTarget(self, action: #selector(optionPressed), for: .touchUpInside)
            button.setTitle(answer, for: UIControlState())
        }
/*
        let btnframe = optionA?.frame
        optionB?.frame = btnframe!
*/
        dismissBtn = UIButton(frame: CGRect(x: frame.width - 40, y: 5, width: 40, height: 40))
        dismissBtn?.setTitle("X", for: UIControlState())
        dismissBtn?.backgroundColor = UIColor.darkGray
        dismissBtn?.setTitleColor(UIColor.white, for: UIControlState())
        dismissBtn?.addTarget(self, action: #selector(dismissView), for: .touchUpInside)


        self.view.addSubview(topicTitle!)
        self.view.addSubview(topicSubtitle!)
        self.view.addSubview(topicDetail!)
        self.view.addSubview(topicImage!)

        self.view.addSubview(optionA!)
        self.view.addSubview(optionB!)
        self.view.addSubview(optionC!)
        self.view.addSubview(optionD!)
        self.view.addSubview(dismissBtn!)
    }

    @IBAction func optionPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        let tag = button.tag
        print("Button \(tag) was pressed!")
        // if selectedId == button.tag do nothing
        if selectedIdx != tag && selectedIdx >= 0 {
            let prevButton = optionButtons![selectedIdx]
            prevButton.layer.borderWidth = 0
            prevButton.isSelected = false
        }

        if button.isSelected {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2.0
            selectedIdx = tag
        }
    }

    @IBAction func goToMeetPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        print("Button \(button.titleLabel?.text) was pressed!")

        if selectedIdx == -1 {
            print("not selected any button yet")
        } else {
            dataSource!.goToMeet(aTopic!.topic_id!, answer_id: selectedIdx)
        }
    }

    func goToMeetUserPage(_ userCard: NSDictionary) {
        let userViewController = MatchUserViewController()
        userViewController.userCard = userCard
        self.present(userViewController, animated: true, completion: nil)
    }

    func dismissView() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
}
