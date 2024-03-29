//
//  Constants.swift
//  Journal
//
//  Created by Joshua Sharp on 9/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreGraphics

typealias Completion = (_ error: AppError?) -> Void

let coreDataModelName: String   = "ChoreTracker"
let baseFBURL: URL              = URL(string: "https://choretracker-c064c.firebaseio.com/")!
let baseAPIURL: URL             = URL(string: "https://chore-tracker-app.herokuapp.com/")!
let baseURL: URL                = baseFBURL

let useAPI: Bool                = false
let debuging: Bool              = true

let cornerRadius:CGFloat        = 10
