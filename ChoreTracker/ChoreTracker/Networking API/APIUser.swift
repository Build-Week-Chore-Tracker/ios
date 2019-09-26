//
//  APIUser.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/26/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct APIUser: Codable{
    let name:       String?
    let username:   String
    let email:      String?
    let password:   String
}

struct LoginResponse: Codable {
    let message:    String
    let token:      String
    let user:       Int32
}
