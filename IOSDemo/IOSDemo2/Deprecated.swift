//
//  Deprecated.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

//Manually transit the page to another page
func transitToPage(destination otherPage: String, originPage origin: AnyObject) { let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

	let nextViewController = storyBoard.instantiateViewController(withIdentifier: otherPage) as UIViewController
	origin.present(nextViewController, animated: false, completion: nil)

}
