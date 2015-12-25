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
    var status: String?
    var eventId: Int!
    var feedId: Int!
    var timeProcessed: NSDate!
    var startTime: EventTime!
    var endTime: EventTime?
    var hasEndTime: Bool = false
    var isAllDay: Bool = false
    var isMultiDay: Bool = false
    var tags: [String]!
    var url: String!
    var location: [String: String]!
    var post: String!
    var author: String!
    
    // Required to implement ObjectMapper
    required init?(_ map: Map){
        
    }
    
    
    // Default map function doesn't work for dates for some reason hence this
    func dateMap(dict: [String: AnyObject]){
        // Events will always have a start time and therefore a date
        
        let dateFromJson = NSDate(timeIntervalSince1970: NSTimeInterval(Int(dict["start_time"] as! String)!)/1000)
        self.startTime = EventTime()
        self.startTime.setAll(dateFromJson)
        
        if (self.startTime.hour == 0 && self.startTime.minute == 0){
            self.isAllDay = true
        }
        
        if (dict["date"] != nil){
            self.dateNS = NSDate(timeIntervalSince1970: NSTimeInterval(dict["date"] as! String)!)
            self.date = CVDate(date: self.dateNS)
        }
        
        if (dict["end_time"] != nil) {
            if let end = dict["end_time"] as? String {
                self.endTime = EventTime()
                self.endTime!.setAll(NSDate(timeIntervalSince1970: NSTimeInterval(String(Int(end)!/1000))!))
                self.hasEndTime = true
                if !sameDate(self.endTime!.dateCV, date2: self.startTime.dateCV){
                    self.isMultiDay = true
                }
            }
            else {
                self.hasEndTime = false
            }
        }
        else {
            self.hasEndTime = false
        }
    }
    
    func locationToString() -> String {
        var locationStr = ""
        if self.location["name"] != nil {
            locationStr = self.location["name"]! + "\n"
        }
        if self.location["street"] != nil {
            locationStr = locationStr + self.location["street"]! + "\n"
        }
        if self.location["state"] != nil {
            locationStr = locationStr + self.location["state"]! + "\n"
        }
        if self.location["state"] != nil {
            locationStr = locationStr + self.location["country"]! + "\n"
        }
        return locationStr
    }
    
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.status <- map["status"]
        self.eventId <- map["event_id"]
        self.feedId <- map["feed_id"]
        self.timeProcessed <- map["time_processed"]
        self.tags <- map["tags"]
        self.url <- map["url"]
        self.location <- map["location"]
        self.post <- map["post"]
        self.isAllDay <- map["is_all_day"]
        self.author <- map["author"]
    }
    
    
    
}
