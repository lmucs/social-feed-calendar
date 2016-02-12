//
//  CalendarViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/17/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var events: [Event]!
    var filteredEvents: [Event]!
    var inMonthView: Bool = true
    var currentCalDate: Date!
    var tabBarView: GrapevineTabViewController!
    var navBarView: GrapevineNavigationController!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView.delegate = self
        self.calendarView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.calendarView.layer.borderColor = UIColor(red:0.27, green:0.72, blue:0.45, alpha:1.0).CGColor
        self.calendarView.layer.borderWidth = 2
        if let parent = self.navigationController as? GrapevineNavigationController {
            self.navBarView = parent
            if let grandparent = parent.tabBarController as? GrapevineTabViewController {
                self.tabBarView = grandparent
            }
        }
        else {
            // we should not get here
        }
        self.title = "Calendar"
        self.navigationItem.title = (monthIntToMonthString(self.calendarView.presentedDate) + " " + String(self.calendarView.presentedDate.year))
        
        
        self.filterEvents(Date(date: NSDate()))
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    @IBAction func changeView(sender: UIBarButtonItem){
        if self.inMonthView {
            self.toWeekView()
            sender.title = "Month"
        }
        else {
            self.toMonthView()
            sender.title = "Week"
        }
    }
    
    func toWeekView() {
        calendarView.changeMode(.WeekView)
        self.inMonthView = false
    }
    
    func toMonthView() {
        calendarView.changeMode(.MonthView)
        self.inMonthView = true
    }
    
    // Mark: - CVCalendarView Delegate Functions
    
    // Required
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    // Required
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        for event in self.events {
            if event.endTime != nil {
                return isInDateRange(event.startTime.dateCV, endDate: event.endTime!.dateCV, testDate: dayView.date)
            }
            if sameDate(event.startTime.dateCV, date2: dayView.date) {
                return true
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.blueColor()]
    }
    
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 14
    }
    
    func filterEvents(date: Date){
        self.filteredEvents = []
        self.currentCalDate = date
        for event in events {
            if event.endTime != nil {
                if isInDateRange(event.startTime.dateCV, endDate: event.endTime!.dateCV, testDate: date){
                    filteredEvents.append(event)
                }
            }
            else {
                if sameDate(event.startTime.dateCV, date2: date){
                    filteredEvents.append(event)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func presentedDateUpdated(date: Date){
        if date.month != self.currentCalDate.month {
            self.navigationItem.title = monthIntToMonthString(date) + " " + String(date.year)
        }
        
        filterEvents(date)
    }

    /*
    * Functions available to be implemented if needed

    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
    
    }

    func didShowNextMonthView(date: NSDate){
        print("month print")
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowPreviousMonthView(date: NSDate){
        print("month print")
        let cvDate = CVDate(date: date)
        self.title =  monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func shouldShowWeekdaysOut() -> Bool {
    
    }
    
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
    
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
    }
    */
    
    
    // Mark: - CVCalendar Menu Delegate Optional Functions
    
    func dayOfWeekTextUppercase() -> Bool{
        return true
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    /*
    * Functions available to be implemented if needed
    func firstWeekday() -> Weekday {
        
    }
    
    func dayOfWeekTextUppercase() -> Bool {
        
    }
    
    func dayOfWeekFont() -> UIFont {
        
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        
    }
    */
    
    
    // Mark: - Table View Delegate Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let month = monthIntToMonthString(self.currentCalDate)
        let day = String(self.currentCalDate.day)
        let year = String(self.currentCalDate.year)
        return month + " " + day + ", " + year
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.filteredEvents != nil {
            return self.filteredEvents.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarEventCell", forIndexPath: indexPath) as! EventTableViewCell
        let event = self.filteredEvents[indexPath.row]
        if event.title != nil {
            cell.eventNameLabel.text = event.title
        }
        else {
            cell.eventNameLabel.text = event.author
        }
        
        cell.eventTimeLabel.text = buildEventTimeRange(event)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            removeEvent(indexPath.row)
        }
    }
    
    func removeEvent(row: Int) {
        let indexPath = NSIndexPath(forItem: row, inSection: 0)
        let eventToRemove = self.filteredEvents[row]
        self.filteredEvents.removeAtIndex(row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        for var index = 0; index < self.events.count; ++index {
            if self.events[index].eventId == eventToRemove.eventId {
                self.events.removeAtIndex(index)
                break
            }
        }
        self.tabBarView.myEvents = self.events
        self.tabBarView.eventListView.events = self.events
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
        return self.filteredEvents[path.row]
    }
    
    @IBAction func backToCalendarViewController(segue:UIStoryboardSegue){
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "eventDetailFromCalendar" {
            let nav = segue.destinationViewController as! UINavigationController
            let detailView = nav.topViewController as! EventDetailViewController
            let path = self.tableView.indexPathForSelectedRow!
            detailView.event = eventAtIndexPath(path)
            
        }
    }


}
