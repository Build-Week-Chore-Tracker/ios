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
        guard   let chore_template_id = self.chore_template?.id,
                let created_date = created_date,
                let owner_user = self.owner
                else { return nil }
        let assigned_user_id = assigned_user?.id ?? nil
        return  ChoreRepresentation(id: id,
                                   chore_template_id: chore_template_id,
                                   created_date: created_date.iso8601(),
                                   due_date: due_date?.iso8601() ?? "",
                                   done_date: done_date?.iso8601(),
                                   approved_date: approved_date?.iso8601(),
                                   assigned_user_id: assigned_user_id,
                                   owner_user_id: owner_user.id,
                                   assignee_comment: assignee_comment ?? nil)
    }
    
    convenience init(id: Int32,
                     chore_template_id: Int32,
                     created_date: Date,
                     due_date: Date,
                     done_date: Date? = nil,
                     approved_date: Date? = nil,
                     assigned_user_id: Int32? = nil,
                     owner_user_id: Int32,
                     assignee_comment: String? = nil,
                     context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self. = chore_template_id
        self.created_date = created_date
        self.name = name
        self.email_address = email_address
        self.child = child
        self.picture = picture
    }
    
    @discardableResult convenience init?(userRepresentaion: UserRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: userRepresentaion.id,
                  login_name: userRepresentaion.login_name,
                  password: userRepresentaion.password,
                  name: userRepresentaion.name,
                  email_address: userRepresentaion.email_address,
                  child: userRepresentaion.child,
                  picture: userRepresentaion.picture,
                  context: context)
    }
}
