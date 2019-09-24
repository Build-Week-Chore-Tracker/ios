//
//  ChoreTemplateRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct ChoreTemplateRepresentation {
    let id:                 Int32
    let name:               String
    let description:        String
    let period:             String
    let picture_evidence:   Bool = false
    let points:             Int?
    let custom:             Bool
    let user_id:            Int32?
    let parent_template_id: Int32?
    let notes:              String?
    let assigned_user_id:   Int32?
}
