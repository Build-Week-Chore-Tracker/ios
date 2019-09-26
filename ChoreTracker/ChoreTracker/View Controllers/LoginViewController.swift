//
//  LoginViewController.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

@IBDesignable
class LoginViewController: UIViewController {

	// MARK: - Properties
    var login: Bool = true


	// MARK: - IBOutlets
	
	@IBOutlet weak var parentSegmentControl: UISegmentedControl!
	@IBOutlet weak var loginSegmentControl: UISegmentedControl!
	@IBOutlet weak var signupLoginLabel: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButtonText: UIButton!
    @IBOutlet weak var regView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loginBackground
        updateViews()
        // Do any additional setup after loading the view.
    }


	@IBAction func parentSegmentControl(_ sender: Any) {
        switch parentSegmentControl.selectedSegmentIndex {
        case 0:
            loginSegmentControl.isHidden = false
        case 1:
            loginSegmentControl.selectedSegmentIndex = 0
            loginSegmentControl.isHidden = true
            login = true
            updateViews()
        default:
            break
        }
	}
    
	@IBAction func loginSegmentControl(_ sender: Any) {
        switch loginSegmentControl.selectedSegmentIndex {
        case 0:
            loginButtonText.setTitle("Login", for: .normal)
            signupLoginLabel.text = "Login"
            login = true
            updateViews()
        case 1:
            login = false
            updateViews()
        default:
            break
        }
	}
    
	@IBAction func loginButtonTapped(_ sender: Any) {
        if login { //Perform Login
            guard let userName = usernameTextField.text, !userName.isEmpty,
                let password = passwordTextField.text, !password.isEmpty
            else {
                //Message user
                alert(vc: self, title: "Error", message: "Please fill out the Username and Password fields.")
            return
            }
            //Login user
            do {
                try UserController.shared.login(loginName: userName, password: password) { error in
                    if UserController.currentUser?.child ?? true {
                        //Segue to Child Dashboard
                        
                        self.performSegue(withIdentifier: "ChildDashboardSegue", sender: self)
                    } else {
                        //Segue to Adult Dashboard
                        self.performSegue(withIdentifier: "AdultDashboardSegue", sender: self)
                    }
                }
            } catch let error as AppError{
                alert(vc: self, AppError: error)
            } catch {
                alert(vc: self, title: "Error", message: String(describing: error))
            }
        } else { //Perform Registration
            guard let userName = usernameTextField.text, !userName.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let fullName = fullNameTextField.text, !fullName.isEmpty,
                let emailAddress = emailTextField.text, !emailAddress.isEmpty
            else {
                //Message user
                alert(vc: self, title: "Error", message: "Please fill out all fields.")
                return
            }
            //Do registration
            do {
                try UserController.shared.register(loginName: userName, password: password, name: fullName, emailAddress: emailAddress, child: false, picture: nil) { error in
                    
                }
                //Success, message user
                login = true
                updateViews()
                alert(vc: self, title: "Success", message: "Registration successful.  You can login now.")
            } catch let error as AppError {
                //Failed, message user
                alert(vc: self, AppError: error)
            } catch {
                NSLog("Error: \(error)")
            }
        }
        
	}
    
    private func updateViews() {
        if login {
            regView.isHidden = true
            loginSegmentControl.selectedSegmentIndex = 0
            loginButtonText.setTitle("Login", for: .normal)
            signupLoginLabel.text = "Login"
        } else {
            regView.isHidden = false
            loginButtonText.setTitle("Register", for: .normal)
            signupLoginLabel.text = "Register"
        }
    }
}
