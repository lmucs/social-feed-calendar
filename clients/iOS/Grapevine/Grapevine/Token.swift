//
//  Token.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/6/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper

class Token: NSObject, Mappable {
    
    var token: String!
    var xkey: String!
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.token <- map["x-access-token"]
        self.xkey <- map["x-key"]
        
    }
    
    func setXKey(xkeyValue: String){
        self.xkey = xkeyValue
    }
    
}
