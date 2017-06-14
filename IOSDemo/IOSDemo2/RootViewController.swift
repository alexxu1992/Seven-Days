//
//  RootViewController.swift
//  IOSDemo2
//
//  Created by Jiahao Zhang on 16/9/15.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit

open class RootViewController: UITabBarController {
	
	var window: UIWindow?
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		self.view.backgroundColor = UIColor.white
		
		self.viewControllers = [MatchMainViewController(), EngageMainViewController(), LastingMainViewController(), MeMainViewController()]
		
		UITabBar.appearance().tintColor = UIColor.blue
		
		self.tabBar.items![0].title = "Match"
		self.tabBar.items![1].title = "Engage"
		self.tabBar.items![2].title = "Lasting"
		self.tabBar.items![3].title = "Me"
	}
	
	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

