//
//  PointsRepresentation.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct PointsRepresentation: Codable, Equatable {
    let id:            Int32
    let userID:        Int32
    let startDate:     String
    let endDate:       String
    let totalPoints:   Int32
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalPoints = "total_points"
    }
}
