//
//  ChoreTemplate+Convenience.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension ChoreTemplate {
    
    var choreTemplateRepresentation: ChoreTemplateRepresentation? {
        guard   let name = self.name,
                let period = self.period
                else { return nil }
        return  ChoreTemplateRepresentation(id: id,
                                    name: name,
                                    description: description,
                                    period: period,
                                    pictureEvidence: pictureEvidence,
                                    points: points,
                                    custom: custom,
                                    userID: self.owner?.id,
                                    parentTemplateID: self.parentTemplate?.id,
                                    notes: notes,
                                    assignedUserID: self.assignedUser?.id)
    }
    
    convenience init(id: Int32,
                     name: String,
                     choreDescription: String,
                     period: String,
                     pictureEvidence: Bool,
                     points: Int32?,
                     custom: Bool,
                     owner: User,
                     notes: String,
                     parentTemplate: ChoreTemplate?,
                     assignedUser: User?,
                     context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id =               id
        self.name =             name
        self.choreDescription = choreDescription
        self.period =           period
        self.pictureEvidence =  pictureEvidence
        if let points = points {
            self.points =       points
        }
        self.custom =           custom
        self.owner =            owner
        self.notes =            notes
        self.parentTemplate =   parentTemplate
        self.assignedUser =     assignedUser
    }
    
    @discardableResult convenience init?(choreTemplateRepresentaion: ChoreTemplateRepresentation, context: NSManagedObjectContext) {
        guard   let ownerID = choreTemplateRepresentaion.userID,
                let owner = UserController.shared.getUser(from: ownerID),
                let assignedID = choreTemplateRepresentaion.assignedUserID,
                let assigned = UserController.shared.getUser(from: assignedID)
        else { return nil }
        
        self.init(id: choreTemplateRepresentaion.id,
                  name: choreTemplateRepresentaion.name,
                  choreDescription: choreTemplateRepresentaion.description,
                  period: choreTemplateRepresentaion.period,
                  pictureEvidence: choreTemplateRepresentaion.pictureEvidence,
                  points: choreTemplateRepresentaion.points,
                  custom: choreTemplateRepresentaion.custom,
                  owner: owner,
                  notes: choreTemplateRepresentaion.notes ?? "",
                  //TODO: - Get ChoreTemplate from ID
                  parentTemplate: nil,
                  assignedUser: assigned,
                  context: context)
    }
}
