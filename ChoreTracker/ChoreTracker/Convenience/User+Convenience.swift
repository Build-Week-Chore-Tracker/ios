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
        guard   let loginName = loginName,
                let password = password,
                let emailAddress = emailAddress,
                let name = name
                else {return nil}
        return UserRepresentation(id: id, loginName: loginName, password: password, name: name, emailAddress: emailAddress, parentID: self.parent?.id ?? nil, picture: picture ?? nil)
    }
    
    convenience init(id: Int32, loginName: String, password: String, name: String, emailAddress: String?, child: Bool, picture: String? = nil,  context: NSManagedObjectContext) {
        
        // Setting up the generic NSManagedObject functionality of the model object
        // The generic chunk of clay
        self.init(context: context)
        
        // Once we have the clay, we can begin sculpting it into our unique model object
        self.id = id
        self.loginName = loginName
        self.password = password
        self.name = name
        self.emailAddress = emailAddress
        self.child = child
        self.picture = picture
    }
    
    @discardableResult convenience init?(userRepresentaion: UserRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: userRepresentaion.id,
                  loginName: userRepresentaion.loginName,
                  password: userRepresentaion.password,
                  name: userRepresentaion.name,
                  emailAddress: userRepresentaion.emailAddress,
                  child: userRepresentaion.child,
                  picture: userRepresentaion.picture,
                  context: context)
    }
}
