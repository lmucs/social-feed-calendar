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
    
    required init?(_ map: Map){
        
    }
    
    //Requirement for Mappable
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
    }
    
    
    
}
