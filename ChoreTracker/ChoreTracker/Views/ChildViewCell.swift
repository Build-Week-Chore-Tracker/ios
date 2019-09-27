//
//  ChildViewCell.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import UIKit

class ChildViewCell: UITableViewCell {

	@IBOutlet weak var choreLabel: UILabel!
	@IBOutlet weak var dueDateLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!

	var chore: Chore? {
		didSet {

		}
	}

	func updateViews() {
		guard let chore = chore else { return }

		choreLabel.text = chore.choreTemplate?.name
		dueDateLabel.text = "\(String(describing: chore.dueDate))"
		pointsLabel.text = "\(String(describing: chore.choreTemplate?.points))"
	}
}
