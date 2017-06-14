//
//  SwiftEssential.swift
//  IOSDemo
//
//  Created by  Eric Wang on 6/25/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

// Auto format for swift :
// 1. Install Alcatraz for Xcode https://github.com/alcatraz/Alcatraz
// 2. Relaunch the Xcode
// 3. Clone and build the Swimat in Xcode https://github.com/Jintin/Swimat
// 4. Relaunch the Xcode
// 5. Open Alcatraz in Xcode/Window/PackageManager
// 6. Find and enable Swimat in installed plugins
// 7. Find Swimat in Edit/Swimat and enable "Format When Save"

import Foundation

protocol SwiftEssentialProtocol {
	var requiredMember: String { get } // Read Only
	func requiredMethod ()
}

open class SwiftEssential: NSObject, SwiftEssentialProtocol {
	var version = 1.0
	var requiredMember: String
	func requiredMethod() {
		return
	}
	// ? for failable initializer, which returns nil
	// required -> every subclass must have its own version
	// When referring to a constant value of a class, to judge whether it's the value of current class or its sub class, use 'as ClassName', and 'as?' for optional and 'as!' for unwrapped
	required public init ?(version: Double?) {
		self.requiredMember = "required"
		super.init()
		if let v = version, v > self.version {
			self.version = v
		}
		else {
			return nil
		}
		
	}
	
	override open class func description() -> String {
		return "This is just a tutorial!"
	}
	
	func tutorial(_ parameter1: String, parameter2: Int) -> Bool {
		// 1. Variables
		
		// var for varibale, let for constant
		var label = "IOS"
		label = "IOS_NEW"
		let width = 1
		let apples: Int? = 100
		
		// Optionals
		let optionalInt: Int? = 10
		
		// Force unwrap operator (!) only when the underlying value is not 'nil'
		let actualInt: Int = optionalInt!
		
		// Implicitly unwrapped optional -> mostly used for Outlets
		let implicitlyUnwrappedOptionalInt: Int! = 1
		
		// Values are never implicitly converted to another type.
		let widthLabel = label + String(width)
		let appleSummary = "I have \(apples) apples."
		print ((String)(actualInt + implicitlyUnwrappedOptionalInt) + widthLabel + appleSummary)
		// 2. Arrays & Dictionary
		
		var array = ["a", "b"]
		array.append("c")
		// Initialize empty
		let emptyArray = [String]()
		var emptyDictionary = [String: Float]()
		emptyDictionary = [:] // To Empty
		print(array[0] + emptyArray.description + emptyDictionary.description)
		
		// 3. Conditional statements
		
		// Constant assignment returns boolean
		if let test = optionalInt {
			print("optionalInt has a value \(test)")
		}
		
		// One if statement to bind multiple values: where
		let optionalHello: String? = "Hello"
		if let hello = optionalHello, hello.hasPrefix("H"), let test = optionalInt {
			print ("optionalHello and optionalInt has values \(hello + (String)(test))")
		}
		
		// 4. For Loop
		for i in 0..<4 { print (i) } // 0-3
		for _ in 0...4 { } // 0-4 & '_' is a wildcard
		let numbers = [1, 2, 3, 4]
		var total = 0
		for number in numbers {
			if number > 0 {
				total += number
			}
			else {
				total += 0
			}
		}
		
		// 5. Switch
		
		// Powerful : a. Support string and other data type -> b. And no break
		let fruit = "apple"
		switch fruit {
		case "apple":
			print("Apple!")
		case "banana":
			print("Banana!")
		default:
			print("What?")
		}
		
		// 6. Enumeration - https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html
		enum Rank: Int {
			case ace = 1
			case two, three, four // Raw-value type of enumeration is Int -> Implicitly set value for them
			case last = -1
		}
		var ace = Rank.ace
		ace = Rank.last
		print(ace)
		//		switch ace {
		//		case .Ace:
		//			print(Rank.Ace)
		//		default:
		//			print(Rank.Last)
		//		}
		
		// 7. Structure -> copied when passed where as objects are passed by reference
		struct Card {
			let num = 10
			func printNum() {
				print(num)
			}
		}
		
		return false
		
	}
}

