//
//  Extensions.swift
//  IOSDemo2
//
//  Created by  Eric Wang on 10/8/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import Foundation
import UIKit

// Close keyboard if user tap anywhere inside the controller
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
	func localizedWithComment(_ comment: String) -> String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
	}

	var lastPathComponent: String {
		get {
			return (self as NSString).lastPathComponent
		}
	}
	var pathExtension: String {
		get {
			return (self as NSString).pathExtension
		}
	}
	var stringByDeletingLastPathComponent: String {
		get {
			return (self as NSString).deletingLastPathComponent
		}
	}
	var stringByDeletingPathExtension: String {
		get {
			return (self as NSString).deletingPathExtension
		}
	}
	var pathComponents: [String] {
		get {
			return (self as NSString).pathComponents
		}
	}

	func stringByAppendingPathComponent(_ path: String) -> String {
		let nsSt = self as NSString
		return nsSt.appendingPathComponent(path)
	}

	func stringByAppendingPathExtension(_ ext: String) -> String? {
		let nsSt = self as NSString
		return nsSt.appendingPathExtension(ext)
	}
}

//Directly getting image data from a web url, using this by call  thatImageView.imageFromUrl("urlfrombackend")
extension UIImageView {
	public func imageFromUrl(_ urlString: String) {
		if let url = URL(string: urlString) {
			let request = URLRequest(url: url)
			let session = URLSession.shared

			session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
				if let imageData = data as Data? {
					self.image = UIImage(data: imageData)
				}
			}) .resume()

		}
	}
}
