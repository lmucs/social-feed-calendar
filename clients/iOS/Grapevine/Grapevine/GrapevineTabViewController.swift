//
//  GrapevineTabViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/16/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class GrapevineTabViewController: UITabBarController {
    
    var userToken: Token!
    var myEvents = [Event]()
    var eventListView: EventListViewController!
    var calendarView: CalendarViewController!
    var feedsView: FeedManagementViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = grapevineBarColor
        
        let navEventList = self.childViewControllers[0] as! GrapevineNavigationController
        self.eventListView = navEventList.topViewController as! EventListViewController
        let navCalendar = self.childViewControllers[1] as! GrapevineNavigationController
        self.calendarView = navCalendar.topViewController as! CalendarViewController
        let navFeeds = self.childViewControllers[2] as! GrapevineNavigationController
        self.feedsView = navFeeds.topViewController as! FeedManagementViewController
        self.feedsView.userToken = self.userToken!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChildViewsData(){
        self.eventListView.events = self.myEvents
        self.calendarView.events = self.myEvents
    }
    
    func getAllUserEvents(){
        let getEventsUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID!) + "/events")
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
        ]
        Alamofire.request(.GET, getEventsUrl!, encoding: .JSON, headers: requestHeader)
            .responseJSON { response in
                if response.1 != nil {
                    if response.1?.statusCode == 200 {
                        let results = response.2.value! as! NSArray
                        for item in results {
                            //debugPrint(item)
                            let responseEvent = Mapper<Event>().map(item)
                            responseEvent?.dateMap(item as! [String : AnyObject])
                            self.myEvents.append(responseEvent!)
                        }
                        self.myEvents.sortInPlace({ $0.startTime.dateNS.compare($1.startTime.dateNS) == NSComparisonResult.OrderedAscending })
                        self.updateChildViewsData()
                        self.eventListView.refreshControl.endRefreshing()
                        self.eventListView.tableView.reloadData()
                        self.eventListView.lastUpdated = NSDate()
                    }
                    else {
                        self.eventListView.refreshControl.endRefreshing()
                    }
                }
                else {
                    self.eventListView.refreshControl.endRefreshing()
                }
        }
    }
    
    func getEventsSince(date: NSDate){
        let getEventsSinceUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID!) + "/events/" + String(Int(self.eventListView.lastUpdated.timeIntervalSince1970 * 1000)))
        print(getEventsSinceUrl)
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
        ]
        self.eventListView.refreshControl.beginRefreshing()
        self.eventListView.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        Alamofire.request(.GET, getEventsSinceUrl!, encoding: .JSON, headers: requestHeader)
            .responseJSON { response in
                debugPrint(response)
                if response.1 != nil {
                    if response.1?.statusCode == 200 {
                        let results = response.2.value! as! NSArray
                        for item in results {
                            debugPrint(item)
                            let responseEvent = Mapper<Event>().map(item)
                            responseEvent?.dateMap(item as! [String : AnyObject])
                            self.myEvents.append(responseEvent!)
                        }
                        
                        self.myEvents.sortInPlace({ $0.startTime.dateNS.compare($1.startTime.dateNS) == NSComparisonResult.OrderedAscending })
                        self.updateChildViewsData()
                        self.eventListView.refreshControl.endRefreshing()
                        self.eventListView.tableView.reloadData()
                        self.eventListView.lastUpdated = NSDate()
                    }
                    else {
                        self.eventListView.refreshControl.endRefreshing()
                    }
                }
                else {
                    self.eventListView.refreshControl.endRefreshing()
                }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToEventList"{
        
        }
        
        if segue.identifier == "goToCalendar" {
            let nav = segue.destinationViewController as! GrapevineNavigationController
            let calendarView = nav.topViewController as! CalendarViewController
            calendarView.events = self.myEvents
        }
        
        if segue.identifier == "goToFeedManagement" {
            let nav = segue.destinationViewController as! GrapevineNavigationController
            let feedView = nav.topViewController as! FeedManagementViewController
            feedView.userToken = self.userToken
            if feedView.myFeeds.count == 0 {
                feedView.getFeeds()
            }
        }
            
    }


}
