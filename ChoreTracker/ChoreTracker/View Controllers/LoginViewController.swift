//
//  LoginViewController.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var parentSegmentControl: UISegmentedControl!
	@IBOutlet weak var loginSegmentControl: UISegmentedControl!
	@IBOutlet weak var signupLoginLabel: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButtonText: UIButton!


	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


	@IBAction func parentSegmentControl(_ sender: Any) {
	}
	@IBAction func loginSegmentControl(_ sender: Any) {
	}
	@IBAction func loginButtonTapped(_ sender: Any) {
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
