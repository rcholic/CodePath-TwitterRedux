//
//  Date+ext.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

extension Date {
    
    func timeSince(from: Date) -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: from, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year) year" :
                "\(year) years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month) month" :
                "\(month) months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) day" : "\(day) days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) hour" : "\(hour) hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute) minute" : "\(minute) minutes"
        } else {
            return "seconds"
        }

    }
}
