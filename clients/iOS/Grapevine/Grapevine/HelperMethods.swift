//
//  HelperMethods.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/22/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import Foundation
import CVCalendar

let apiBaseUrl = "http://localhost:8000"

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


func sameDate(date1: CVDate, date2: CVDate) -> Bool {
    if ((date1.month == date2.month) && (date2.day == date1.day) && (date1.year == date2.year)) {
        return true
    }
    return false
}



