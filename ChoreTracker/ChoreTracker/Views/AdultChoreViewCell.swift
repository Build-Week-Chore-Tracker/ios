//
//  AdultChoreViewCell.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdultChoreViewCell: UITableViewCell {
    
    var chore: Chore?{
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var choreLabel: UILabel!
    
    
    
    private func updateViews() {
        if let chore = chore {
            
        }
    }
}
