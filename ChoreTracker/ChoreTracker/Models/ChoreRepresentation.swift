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
    let choreTemplateID:    Int32
    let createdDate:        String
    let dueDate:            String
    let doneDate:           String?
    let approvedDate:       String?
    let assignedUserID:     Int32?
    let ownerUserID:        Int32
    let assigneeComment:    String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case choreTemplateID = "chore_template_id"
        case createdDate = "created_date"
        case dueDate = "due_date"
        case doneDate = "done_date"
        case approvedDate = "approved_date"
        case assignedUserID = "assigned_user_id"
        case ownerUserID = "owner_user_id"
        case assigneeComment = "assignee_comment"
    }
}
