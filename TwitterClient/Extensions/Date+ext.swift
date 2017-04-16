//
//  Date+ext.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

internal enum TimeZoneEnum: String {
    case utc = "UTC"
    case est = "EST"
    case edt = "EDT"
    case cst = "CST"
    case cdt = "CDT"
    case mst = "MST"
    case mdt = "MDT"
    case pst = "PST"
    case pdt = "PDT"
}

extension Date {
    
    // MARK: time since earlier date
    func timeSince(_ earlierDate: Date, numerical:Bool = false) -> String {
        let calendar = Calendar.current
        let now = self
        let earliest = (now as NSDate).earlierDate(earlierDate)
        let latest = (earliest == now) ? earlierDate : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years"
        } else if (components.year! >= 1){
            if (numerical){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numerical){
                return "1 month"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numerical){
                return "1 week"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numerical){
                return "1 day"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hrs"
        } else if (components.hour! >= 1){
            if (numerical){
                return "1 hr"
            } else {
                return "An hour"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes"
        } else if (components.minute! >= 1){
            if (numerical){
                return "1 minute"
            } else {
                return "A minute"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec"
        } else {
            return "Just now"
        }
    }
    
    // get Now time based on timezone abbreviation, e.g. "UTC" and date format
    func toTimezone(_ timezone: TimeZoneEnum?, dateFormat: String) -> Date {
        let tz = timezone ?? TimeZoneEnum.utc
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: tz.rawValue)
        dateFormatter.dateFormat = dateFormat
        let nowStr = dateFormatter.string(from: self)
        
        return dateFormatter.date(from: nowStr) ?? Date()
    }
}
