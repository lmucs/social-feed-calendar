//
//  EventListTableViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import CVCalendar
import ObjectMapper

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userToken: Token!
    var events: [Event] = []
    var lastUpdated: NSDate!
    var refreshView: UIView!
    var refreshControl = UIRefreshControl()
    
    var tabBarView: GrapevineTabViewController!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let imageView = UIImageView(image:textLogoSmall)
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        if let parent = self.navigationController as? GrapevineNavigationController {
            if let grandparent = parent.tabBarController as? GrapevineTabViewController {
                self.tabBarView = grandparent
            }
        }
        else {
            // we should not get here
        }
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "updateEvents:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        loadCustomRefreshContents()
        //self.refreshControl.tintColor = grapevineIndicatorColor
        self.refreshControl.beginRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshView", owner: self, options: nil)
        self.refreshView = refreshContents[0] as! UIView
        self.refreshView.frame = refreshControl.bounds
        self.refreshControl.addSubview(refreshView)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Upcoming Events"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.refreshControl.refreshing {
            return self.events.count + 1
        }
        if self.events.count == 0 {
            return 1
        }
        return events.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func setupEventCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
            let event = self.events[indexPath.row]
            if event.title != nil {
                cell.eventNameLabel.text = event.title
            }
            else {
                cell.eventNameLabel.text = event.author
            }
            
            if !event.isMultiDay {
                cell.eventMultiDayLabel.hidden = true
            }
            else {
                cell.eventMultiDayLabel.hidden = false
            }
            
            func setDateBoxes(dateTime: CVDate){
                cell.eventMonthLabel.text = monthIntToShortMonthString(self.events[indexPath.row].startTime.dateCV.month)
                cell.eventDayLabel.text = String(self.events[indexPath.row].startTime.dateCV.day)
            }
            
            cell.eventTimeLabel.text = buildEventTimeRange(self.events[indexPath.row])
            setDateBoxes(self.events[indexPath.row].startTime.dateCV)
            return cell
        }
        
        
        func setupOtherCell(cellText: String, animateIndicator: Bool) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("noEventsCell", forIndexPath: indexPath) as! NoEventsTableViewCell
            cell.label.text = cellText
            if animateIndicator {
                cell.activityIndicator.startAnimating()
            }
            else {
                cell.activityIndicator.hidden = true
                cell.leftImage.hidden = true
                cell.rightImage.hidden = true
            }
            cell.label.numberOfLines = 0
            return cell
        }
        
        
        if self.refreshControl.refreshing && self.events.count == 0  {
            if indexPath.row == 0 {
                let cellText: String = "Loading your events now, \(self.userToken.firstName) \(self.userToken.lastName)!"
                return setupOtherCell(cellText, animateIndicator: false)
            }
            return setupEventCell()
        }

        
        if events.count == 0 {
            let cellText: String = "You have no events, \(self.userToken.firstName) \(self.userToken.lastName)! Add some feeds to get some!"
            return setupOtherCell(cellText, animateIndicator: false)
        }
        return setupEventCell()

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            removeEvent(indexPath.row)
        }
    }
    
    func removeEvent(row: Int) {
        let indexPath = NSIndexPath(forItem: row, inSection: 0)
        self.events.removeAtIndex(row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tabBarView.myEvents = self.events
        self.tabBarView.calendarView.events = self.events
    }
    
    @IBAction func backToEventListViewController(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func updateEvents(sender: AnyObject){
        tabBarView.getEventsSince(self.lastUpdated)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func eventAtIndexPath(path: NSIndexPath) -> Event {
        return self.events[path.row]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToEventDetailSegue" {
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! GrapevineNavigationController
            let detailView = nav.topViewController as! EventDetailViewController
            //detailView.rightBarButton.enabled = false
            detailView.event = eventAtIndexPath(path)
        }
        
        
        
        
    }


}
