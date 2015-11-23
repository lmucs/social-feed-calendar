//
//  Event.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/29/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper
import CVCalendar

class Event: NSObject, Mappable {
    var title: String!
    var dateNS: NSDate!
    var date: CVDate!
    var status: String!
    var eventId: Int!
    var feedId: Int!
    var timeProcessed: NSDate!
    var startTimeNS: NSDate!
    var startTime: CVDate!
    var endTimeNS: NSDate!
    var endTime: CVDate!
    var repeatsWeekly: Int!
    var tags: [String]!
    var url: String!
    var location: String!
    var post: String!
    
    // Required to implement ObjectMapper
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.dateNS <- (map["date"], DateTransform())
        self.status <- map["status"]
        self.eventId <- map["event_id"]
        self.feedId <- map["feed_id"]
        self.timeProcessed <- (map["time_processed"], DateTransform())
        self.startTimeNS <- (map["start_time"], DateTransform())
        self.endTimeNS <- (map["end_time"], DateTransform())
        self.repeatsWeekly <- map["repeats_weekly"]
        self.tags <- map["tags"]
        self.url <- map["url"]
        self.location <- map["location"]
        self.post <- map["post"]
        
    }
    
    
    
}
