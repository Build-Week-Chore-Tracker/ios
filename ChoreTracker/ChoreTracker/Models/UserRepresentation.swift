//
//  UserRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable, Equatable {
    let id:             Int32
    let loginName:      String
    let password:       String
    let name:           String
    let emailAddress:   String?
    let child:          Bool = false
    let parentID:       Int32?
    let picture:        String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case loginName = "login_name"
        case password
        case name
        case emailAddress = "email_address"
        case child
        case parentID = "parent_id"
        case picture
    }
}
