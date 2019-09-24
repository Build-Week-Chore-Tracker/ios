//
//  SettingsRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct SettingsRepresentation: Codable, Equatable {
    let id:             Int32
    let familyPicture:  String?
    let weekStartDay:   String
    
    enum CodingKeys: String, CodingKey {
        case id
        case familyPicture = "family_picture"
        case weekStartDay = "week_start_day"
    }
}
