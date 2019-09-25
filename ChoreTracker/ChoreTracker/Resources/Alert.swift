//
//  Alert.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import UIKit

func alert (vc: UIViewController, title: String, message: String, error: AppError? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    DispatchQueue.main.async {
        vc.present(alert, animated: true, completion: nil)
    }
}
    
func alert (vc: UIViewController, error: AppError) {
    let message = error.rawValue
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    DispatchQueue.main.async {
        vc.present(alert, animated: true, completion: nil)
    }
}
