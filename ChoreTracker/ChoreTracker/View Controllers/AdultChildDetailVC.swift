//
//  AdultChildDetailVC.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class AdultChildDetailVC: UIViewController {

    var user: User?
    var userController: UserController?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var pictureTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            if let user = user { //Update user
                userController?.update(user: user, name: name, loginName: loginName, password: password, emailAddress: emailAddress, child: true, picture: pictureURL)
            } else { //Create/Add user
                try userController?.register(loginName: loginName, password: password, name: name, emailAddress: emailAddress, child: true, picture: pictureURL)
            }
        } catch let error as AppError {
            alert(vc: self, error: error)
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
        if let user = user { //Editing, fill out fields
            nameTextField.text = user.name
            loginNameTextField.text = user.loginName
            passwordTextField.text = user.password
            pictureTextField.text = user.picture
            emailAddressTextField.text = user.emailAddress
            if let pictureURL = user.picture {
                imageView.downloaded(from: pictureURL)
            }
        } else { //Adding new user/child
        
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
