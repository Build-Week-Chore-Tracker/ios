//
//  User+Convenience.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        guard   let login_name = login_name,
                let password = password,
                let email_address = email_address,
                let name = name
                else {return nil}
        return UserRepresentation(id: id, login_name: login_name, password: password, name: name, email_address: email_address, parent_id: self.parent?.id ?? nil, picture: picture ?? nil)
    }
    
    convenience init(id: Int32, login_name: String, password: String, name: String, email_address: String, child: Bool, picture: String? = nil,  context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self.login_name = login_name
        self.password = password
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
