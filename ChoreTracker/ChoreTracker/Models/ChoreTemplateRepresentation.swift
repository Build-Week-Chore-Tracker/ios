//
//  ChoreTemplateRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct ChoreTemplateRepresentation: Codable, Equatable {
    let id:                 Int32
    let name:               String
    let description:        String
    let period:             String
    let pictureEvidence:    Bool
    let points:             Int32?
    let custom:             Bool
    let userID:             Int32?
    let parentTemplateID:   Int32?
    let notes:              String?
    let assignedUserID:     Int32?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case period
        case pictureEvidence = "picture_evidence"
        case points
        case custom
        case userID = "user_id"
        case parentTemplateID = "parent_template_id"
        case notes
        case assignedUserID = "assigned_user_id"
    }
}
