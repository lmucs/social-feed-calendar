//
//  HelperMethods.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/22/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import Foundation
import CVCalendar

let apiBaseUrl = "https://grapevine.herokuapp.com"

let grapevineButtonColor = UIColor(red:0.54, green:0.07, blue:0.53, alpha:1.0)
let grapevineButtonCornerRadius: CGFloat = 10

let grapevineBarColor = UIColor(red:0.81, green:0.66, blue:0.81, alpha:1.0)
let grapevineIndicatorColor = UIColor(red:0.27, green:0.72, blue:0.45, alpha:1.0)

let textLogo = UIImage(named: "grapevine-logo-full-words-outline2swag.png")
let textLogoSmall = UIImage(named: "grapevine-logo-full-words-outline2swag40h")


// User feedback on text fields

func setErrorColor(textField: UITextField) {
    let errorColor : UIColor = UIColor.redColor()
    textField.layer.borderColor = errorColor.CGColor
    textField.layer.borderWidth = 1.5
}

func setSuccessColor(textField: UITextField) {
    let successColor : UIColor = UIColor( red: 0.3, green: 0.5, blue:0.3, alpha: 1.0 )
    textField.layer.borderColor = successColor.CGColor
    textField.layer.borderWidth = 1.5
}

func setupGrapevineButton(button: UIButton){
    button.backgroundColor = grapevineButtonColor
    button.layer.cornerRadius = grapevineButtonCornerRadius
}

func disableGrapevineButton(button: UIButton){
    button.enabled = false
    button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
}

func enableGrapevineButton(button: UIButton){
    button.enabled = true
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
}

// Date String Functions

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
        return "December"
    default:
        return "Not a month"
    }
}

func monthIntToShortMonthString(month: Int) -> String {
    switch month {
    case 1:
        return "JAN"
    case 2:
        return "FEB"
    case 3:
        return "MAR"
    case 4:
        return "APR"
    case 5:
        return "MAY"
    case 6:
        return "JUN"
    case 7:
        return "JUL"
    case 8:
        return "AUG"
    case 9:
        return "SEP"
    case 10:
        return "OCT"
    case 11:
        return "NOV"
    case 12:
        return "DEC"
    default:
        return "Not a month"
    }
}

func monthIntToLowerCaseShortMonthString(month: Int) -> String {
    var lowercase = monthIntToShortMonthString(month).lowercaseString
    lowercase.replaceRange(Range(start: lowercase.startIndex, end: lowercase.startIndex.successor()), with: String(lowercase[lowercase.startIndex]).capitalizedString)
    return lowercase
}


func sameDate(date1: CVDate, date2: CVDate) -> Bool {
    if ((date1.month == date2.month) && (date2.day == date1.day) && (date1.year == date2.year)) {
        return true
    }
    return false
}

func date1LessThanDate2(date1: CVDate, date2: CVDate) -> Bool {
    if (date1.year < date2.year){
        return true
    }
    if (date1.year == date2.year){
        if (date1.month < date2.month){
            return true
        }
        if (date1.month == date2.month){
            if (date1.day < date2.day) {
                return true
            }
        }
    }
    return false
}

func isInDateRange(startDate: CVDate, endDate: CVDate, testDate: CVDate) -> Bool {
    if sameDate(startDate, date2: testDate){
        return true
    }
    if sameDate(endDate, date2: testDate){
        return true
    }
    if date1LessThanDate2(startDate, date2: testDate) && date1LessThanDate2(testDate, date2: endDate) {
        return true
    }
    return false
}

// Yeah i know this is messy as hell will fix later
func buildTimeString(time: EventTime, militaryTime: Bool) -> String {
    if !militaryTime {
        if time.hour < 12 {
            if time.hour == 0 {
                return String(time.hour + 12) + ":" + time.minuteToString() + "am"
            }
            return String(time.hour) + ":" + time.minuteToString() + "am"
        }
        if time.hour == 12 {
            return String(time.hour) + ":" + time.minuteToString() + "pm"
        }
        return String(time.hour % 12) + ":" + time.minuteToString() + "pm"
        
    }
    return String(time.hour) + ":" +  time.minuteToString()
}

func buildEventTimeRange(myEvent: Event) -> String {
    let start = buildTimeString(myEvent.startTime, militaryTime: false)
    if myEvent.hasEndTime {
        if myEvent.isMultiDay {
            return buildMultiDayRange(myEvent)
        }
        let end = buildTimeString(myEvent.endTime!, militaryTime: false)
        return start + "-" + end
    }
    if myEvent.isAllDay{
        return "All-Day"
    }
    return "Starts at " + start
    
}

func buildEventDateString(date: CVDate) -> String {
    let month = monthIntToMonthString(date)
    let day = String(date.day)
    let year = String(date.year)
    return month + " " + day + ", " + year
}

func buildEventShortDateString(date: CVDate) -> String {
    let month = monthIntToLowerCaseShortMonthString(date.month)
    let day = String(date.day)
    let year = String(date.year)
    return month + " " + day + ", " + year
}

func buildMultiDayRange(event: Event) -> String {
    let startDateStr = String(buildEventShortDateString(event.startTime.dateCV))
    let endDateStr = String(buildEventShortDateString(event.endTime!.dateCV))
    let timeStr = startDateStr + " - " + endDateStr
    return timeStr
}



