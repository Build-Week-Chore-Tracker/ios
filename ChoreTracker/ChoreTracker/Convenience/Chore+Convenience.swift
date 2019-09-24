//
//  Chore+Convenience.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Chore {
    
    var choreRepresentation: ChoreRepresentation? {
        guard   let choreTemplateID = self.choreTemplate?.id,
                let createdDate = createdDate,
                let ownerUser = self.owner
                else { return nil }
        let assignedUserID = assignedUser?.id ?? nil
        return  ChoreRepresentation(id: id,
                                   choreTemplateID: choreTemplateID,
                                   createdDate: createdDate.iso8601(),
                                   dueDate: dueDate?.iso8601() ?? "",
                                   doneDate: doneDate?.iso8601(),
                                   approvedDate: approvedDate?.iso8601(),
                                   assignedUserID: assignedUserID,
                                   ownerUserID: ownerUser.id,
                                   assigneeComment: assigneeComment ?? nil)
    }
    
    convenience init(id: Int32,
                     choreTemplateID: Int32,
                     createdDate: Date,
                     dueDate: Date,
                     doneDate: Date? = nil,
                     approvedDate: Date? = nil,
                     assignedUserID: Int32? = nil,
                     ownerUserID: Int32,
                     assigneeComment: String? = nil,
                     context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self.choreTemplate = nil  //TODO: - Implement ChoreTemplate lookup by ID
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.doneDate = doneDate
        self.approvedDate = approvedDate
        self.assignedUser = nil  //TODO: - Implement user lookup by ID
        self.owner = nil
        self.assigneeComment = assigneeComment
    }
    
    @discardableResult convenience init?(choreRepresentaion: ChoreRepresentation, context: NSManagedObjectContext) {
        
        let formatter = ISO8601DateFormatter()
        guard
            let createdDate = formatter.date(from: choreRepresentaion.createdDate),
            let dueDate = formatter.date(from: choreRepresentaion.dueDate)
        else { return nil}
        let doneDate = formatter.date(from: choreRepresentaion.doneDate ?? "")
        let approvedDate = formatter.date(from: choreRepresentaion.approvedDate ?? "")
        
        self.init(id: choreRepresentaion.id,
                  choreTemplateID: choreRepresentaion.choreTemplateID,
                  createdDate: createdDate,
                  dueDate: dueDate,
                  doneDate: doneDate,
                  approvedDate: approvedDate,
                  assignedUserID: choreRepresentaion.assignedUserID,
                  ownerUserID: choreRepresentaion.ownerUserID,
                  assigneeComment: choreRepresentaion.assigneeComment,
                  context: context)
    }
}
