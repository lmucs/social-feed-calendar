//
//  User.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/1/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject, Mappable {
    var username: String!
    private var password: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var userID: Int!
    
    required init?(_ map: Map){
        
    }
    
    //Requirement for Mappable
    func mapping(map: Map) {
        self.username <- map["username"]
        self.password <- map["password"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
        self.email <- map["email"]
        self.userID <- map["userID"]
        
    }
    
    
    
}
