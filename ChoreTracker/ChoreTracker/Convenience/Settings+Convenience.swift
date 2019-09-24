//
//  Settings+Convenience.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Settings {
    
    var settingsRepresentation: SettingsRepresentation? {
        guard   let familyPicture = self.familyPicture,
                let weekStartDay = self.weekStartDay
        else { return nil }
        return  SettingsRepresentation(id: id,
                                       familyPicture: familyPicture,
                                       weekStartDay: weekStartDay)
    }
    
    convenience init(id: Int32,
                     familyPicture: String?,
                     weekStartDay: String,
                     context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self.familyPicture = familyPicture ?? nil
        self.weekStartDay = weekStartDay
    }
    
    @discardableResult convenience init?(settingsRepresentation: SettingsRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: settingsRepresentation.id,
                  familyPicture: settingsRepresentation.familyPicture,
                  weekStartDay: settingsRepresentation.weekStartDay,
                  context: context)
    }
}
