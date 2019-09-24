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
    let login_name:     String
    let password:       String
    let name:           String
    let email_address:  String
    let child:          Bool = false
    let parent_id:      Int32?
    let picture:        String?
}
