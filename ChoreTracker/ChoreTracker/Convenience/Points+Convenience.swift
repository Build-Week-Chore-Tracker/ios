//
//  Points+Convenience.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Points {
    
    var pointsRepresentation: PointsRepresentation? {
        guard   let userID = self.user?.id,
                let startDate = self.startDate?.iso8601(),
                let endDate = self.endDate?.iso8601()
            else { return nil }
        return  PointsRepresentation(id: id,
                                     userID: userID,
                                     startDate: startDate,
                                     endDate: endDate,
                                     totalPoints: self.totalPoints)
    }
    
    convenience init(id: Int32,
                     userID: Int32,
                     startDate: Date,
                     endDate: Date,
                     totalPoints: Int32,
                     context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self.userID = userID
        self.startDate = startDate
        self.endDate = endDate
        self.totalPoints = totalPoints
    }
    
    @discardableResult convenience init?(pointsRepresentaion: PointsRepresentation, context: NSManagedObjectContext) {
        
        let formatter = ISO8601DateFormatter()
        guard
            let startDate = formatter.date(from: pointsRepresentaion.startDate),
            let endDate = formatter.date(from: pointsRepresentaion.endDate)
            else { return nil}
        
        //TODO: - Get User object from ID
        
        self.init(id: pointsRepresentaion.id,
                  userID: nil,
                  startDate: startDate,
                  endDate: endDate,
                  totalPoints: pointsRepresentaion.totalPoints,
                  context: context)
    }
}
