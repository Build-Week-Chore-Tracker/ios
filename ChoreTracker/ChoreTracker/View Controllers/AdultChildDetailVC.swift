//
//  AdultChildDetailVC.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/25/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class AdultChildDetailVC: UIViewController {
   
        //var user: User?
        //var userController: UserController?
        
        @IBOutlet weak var nameTextField: UITextField!
        @IBOutlet weak var loginNameTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var pictureTextField: UITextField!
        @IBOutlet weak var emailAddressTextField: UITextField!
        @IBOutlet weak var imageView: UIImageView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
			view.backgroundColor = .loginBackground
            updateViews()
        }
        
        @IBAction func pictureURLEntered(_ sender: Any) {
        }
        
        @IBAction func saveTapped(_ sender: Any) {
            var pictureURL: String?
            var emailAddress: String?
            
            guard   let name = nameTextField.text,
                !name.isEmpty,
                let loginName = loginNameTextField.text,
                !loginName.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty
                else {
                    alert(vc: self, title: "Error", message: "Please fill out the Full Name, Login Name, and Password fields.")
                    return
            }
            pictureURL = pictureTextField.text ?? nil
            emailAddress = emailAddressTextField.text ?? nil
            do {
                print ("Curent Child = \(String(describing: UserController.currentChild))")
                if let user = UserController.currentChild { //Update user
                    UserController.shared.update(user: user, name: name, loginName: loginName, password: password, emailAddress: emailAddress, child: true, picture: pictureURL)
                } else { //Create/Add user
                    try UserController.shared.register(loginName: loginName, password: password, name: name, emailAddress: emailAddress, child: true, picture: pictureURL)
                }
            } catch let error as AppError {
                alert(vc: self, AppError: error)
                return
            } catch {
                NSLog("Error creating child: \(error)")
                return
            }
            alert(vc: self, title: "Success", message: "Child created successfully.")
            self.performSegue(withIdentifier: "UnwindToAdultChildTableSegue", sender: self)
        }
        
        @IBAction func cancelTapped(_ sender: Any) {
            self.performSegue(withIdentifier: "UnwindToAdultChildTableSegue", sender: self)
        }
        
        private func updateViews() {
            print ("Running updateViews")
            if let user = UserController.currentChild { //Editing, fill out fields
                print ("Current user: \(String(describing: user.name))")
                nameTextField.text = user.name
				nameTextField.backgroundColor = .white
                loginNameTextField.text = user.loginName
				loginNameTextField.backgroundColor = .white
                passwordTextField.text = user.password
				passwordTextField.backgroundColor = .white
                pictureTextField.text = user.picture
				pictureTextField.backgroundColor = .white
                emailAddressTextField.text = user.emailAddress
				emailAddressTextField.backgroundColor = .white
                if let pictureURL = user.picture {
                    imageView.downloaded(from: pictureURL)
                }
            } else { //Adding new user/child
                print ("Adding new child")
            }
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
