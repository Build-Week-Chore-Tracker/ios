//
//  ChildChoreDetailVC.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class ChildChoreDetailVC: UIViewController {

	@IBOutlet weak var choreLabel: UILabel!
	@IBOutlet weak var dueDateLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!

	var choreController: ChoreController?
	var chore: Chore?

	override func viewDidLoad() {
		super.viewDidLoad()

		updateViews()
	}



	@IBAction func completedToggle(_ sender: Any) {


	}

	func updateViews() {

		title = chore?.choreTemplate?.name ?? "Create Chore"

		choreLabel.text = chore?.choreTemplate?.name
		dueDateLabel.text = "\(String(describing: chore?.dueDate))"
		descriptionLabel.text = chore?.choreTemplate?.choreDescription
		//pointsLabel.text = String(chore?.choreTemplate?.points)
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

}
