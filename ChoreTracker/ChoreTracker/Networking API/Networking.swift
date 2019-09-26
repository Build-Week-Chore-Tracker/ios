//
//  Networking.swift
//  Countries
//
//  Created by Joshua Sharp on 9/11/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case encodingError
    case responseError
    case noData
    case noDecode
    case noToken
    case badAuth
    case failedFetch(Error)
    case badURL
    case invalidData
    case failedSignUp(Error)
    case otherError(Error)
    case noEncode
    case noIDReturned
    case failedPost(Error)
    case failedDelete(Error)
    case noUpdate(Error)
}
