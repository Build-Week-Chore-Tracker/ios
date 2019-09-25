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


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


	@IBAction func completedToggle(_ sender: Any) {


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
