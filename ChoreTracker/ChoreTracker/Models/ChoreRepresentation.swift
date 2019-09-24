//
//  ChoreRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct ChoreRepresentation {
    let id:                 Int32
    let chore_template_id:  Int32
    let created_date:       String
    let due_date:           String
    let done_date:          String?
    let approved_date:      String?
    let assigned_user_id:   Int32?
    let owner_user_id:      Int32
    let assignee_comment:   String?
}
