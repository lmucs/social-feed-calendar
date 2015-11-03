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
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView.delegate = self
        self.calendarView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = (monthIntToMonthString(self.calendarView.presentedDate) + " " + String(self.calendarView.presentedDate.year))
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
    
    func monthIntToMonthString(date: CVDate) -> String {
        switch date.month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "Decemeber"
        default:
            return "Not a month"
        }
    }
    
    @IBAction func todayPressed(){
        
    }
    
    @IBAction func weekMonthPressed(sender: UIBarButtonItem){
        let monthStr = "Month"
        let weekStr = "Week"
        if sender.title == weekStr {
            calendarView.calendarMode = .WeekView
            sender.title = monthStr
        }
        else {
            calendarView.calendarMode = .MonthView
            sender.title = weekStr
        }
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
        return true
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.redColor()]
    }
    
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 9
    }
    
    func didShowNextMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowPreviousMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title =  monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    /*
    * Functions available to be implemented if needed
    
    func shouldShowWeekdaysOut() -> Bool {
    
    }
    
    
    func presentedDateUpdated(date: Date){
    
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
    
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("this ran")
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarEventCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.eventNameLabel.text = "Swag Event"
        cell.eventTimeLabel.text = "All-day son"
        return cell
        
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

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
