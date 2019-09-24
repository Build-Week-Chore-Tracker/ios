//
//  Constants.swift
//  Journal
//
//  Created by Joshua Sharp on 9/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation


let coreDataModelName: String   = "ChoreTracker"
let baseURL: URL                = URL(string: "https://choretracker-c064c.firebaseio.com/")!
let useAPI: Bool                = false

enum AppError: Error {
    case objectToRepFailed
}
