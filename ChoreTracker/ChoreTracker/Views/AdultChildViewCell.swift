//
//  AdultChildViewCell.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdultChildViewCell: UITableViewCell {
    
    var user: User?{
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var assignedLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var needsApprovalLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
        
    private func updateViews() {
        if let user = user {
            let userPicture: String = user.picture ?? ""
            if !userPicture.isEmpty {
                childImageView.downloaded(from: userPicture)
            } else {
                childImageView.image = UIImage(named: "child")
            }
            childNameLabel.text = user.name

            //let stats = getUserStats(user: user)

           // let stats = getUserStats(user: user)

        }
    }
}
