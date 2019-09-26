//
//  ErrorHandling.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum AppError: String, Error, Equatable {
    case objectToRepFailed          = "Failed to translate object to Representative."
    case nameNotUnique              = "The username provided is already taken."
    case loginFailedLoginName       = "The username gicen was not found."
    case loginFailedWrongPassword   = "The password was incorrect."
    case errorFetchingData          = "There was an error fatching data."
}
