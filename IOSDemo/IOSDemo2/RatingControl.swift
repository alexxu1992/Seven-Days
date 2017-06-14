//
//  RatingControl.swift
//  IOSDemo
//
//  Created by  Eric Wang on 6/26/16.
//  Copyright © 2016 Nan Guo. All rights reserved.
//

import UIKit

class RatingControl: UIView {
	// MARK: Properties

	// Property Observer
	var rating = 0 {
		// Update the layout of the button view everytime the value changes
		didSet {
			setNeedsLayout()
		}
	}
	var ratingButtons = [UIButton]()
	let spacing = 5
	let starCount = 5

	// MARK: Initialization
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		let filledStarImage = UIImage(named: "filledStar")
		let emptyStarImage = UIImage(named: "emptyStar")

		for _ in 0..<starCount {
			let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
			button.setImage(emptyStarImage, for: UIControlState())
			button.setImage(filledStarImage, for: .selected)
			button.setImage(filledStarImage, for: [.highlighted, .selected])
			// button.backgroundColor = UIColor.redColor()

			// Do not show additional highlight during the state change
			button.adjustsImageWhenHighlighted = false

			button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
			ratingButtons += [button]
			addSubview(button)
		}

	}

	override func layoutSubviews() {
		let buttonSize = Int(frame.size.height)
		var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)

		// Offset the buttons by the length of the button + spacing
		for (index, button) in ratingButtons.enumerated() {
			buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
			button.frame = buttonFrame
		}
		// Initialize button status
		updateButtonSelectionStates()
	}

	override var intrinsicContentSize : CGSize {
		// Rating control's intrinsic content size
		let buttonSize = Int(frame.size.height)
		let width = (buttonSize * starCount) + (spacing * (starCount - 1))
		return CGSize(width: width, height: buttonSize)
	}

	// MARK: Button Action

	func ratingButtonTapped(_ button: UIButton) {
		rating = ratingButtons.index(of: button)! + 1
		updateButtonSelectionStates()
	}

	// MARK: Button helper

	func updateButtonSelectionStates() {
		// To change button status to selected if the index of it is less than the rating
		for (index, button) in ratingButtons.enumerated() {
			button.isSelected = index < rating
		}
	}
}
