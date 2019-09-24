//
//  SettingsRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct SettingsRepresentation {
    let id:             Int
    let familyPicture: String?
    let weekStartDay: String = "Sunday"
    
    enum CodingKeys: String, CodingKey {
        case id
        case familyPicture = "family_picture"
        case weekStartDay = "week_start_day"
    }
}
