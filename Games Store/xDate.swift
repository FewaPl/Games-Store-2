//
//  xdata.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 21/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation



extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style){
    self.init()
    self.dateStyle = dateStyle
}
}
extension Date {
    
    func PlusMinusMinutes (number : Int ) -> Date {
        let GoDate : Date = NSCalendar.current.date(byAdding: .minute, value: number, to: self )!
        return GoDate
    }
    func PlusMinusDays(number: Int) -> Date {
        let GODate : Date = NSCalendar.current.date (byAdding: .day, value: number, to: self)!
        return GODate
    }
    struct Formatter {
        static let shortDate = DateFormatter(dateStyle: .short)
    }
    var shortDate: String {
        return Formatter.shortDate.string(from: self as Date)
    }
    func GetTime() -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "hh:mm a"
        let dateString = formatterDate.string(from: self)
        return dateString
    }
    func dayNumberOfWeek() -> Int? {
        var TodayNumber = Calendar.current.dateComponents([.weekday], from: self).weekday
        if TodayNumber == 7{
            TodayNumber = 0
        }
        return TodayNumber
    }
    func MakeItClearDateForJustHAndM() -> Date {
        let formatterDara1 = DateFormatter()
        formatterDara1.dateFormat = "hh:mm a"
        let ClearDateString = formatterDara1.string(from: self)
        let ClearDate = formatterDara1.date(from: ClearDateString)
        return ClearDate!
    }
    func MakeItToday()-> Date {
        let formatterDare1 = DateFormatter()
        formatterDare1.dateFormat = "hh:mm a"
        let ClearDataString = formatterDare1.string(from: self)
        
        let formatterDare2 = DateFormatter()
        formatterDare2.dateFormat = "yyyy:mm:dd:"
        let ClearDataString2 = formatterDare2.string(from: self)
        
        let TheResult = ClearDataString2 + ClearDataString
        
        let formatterDare3 = DateFormatter()
        formatterDare3.dateFormat = "yyyy:mm:dd:hh:mm a"
        
        let LastDateForToday = formatterDare3.date(from: TheResult)
        return LastDateForToday!
    }
    
    func GetHoursAndMinByStamp() -> Int {
        let formatterData1 = DateFormatter()
        formatterData1.dateFormat = "H:m:s"
        let ClearDateString = formatterData1.string(from: self)
        
        let seperated = ClearDateString.components(separatedBy: ":")
        
        let Hours = Int(seperated[0])
        let Minutes = Int(seperated[1])
        let Seconds = Int(seperated[2])
        
        return (Hours! * 60 * 60) + (Minutes! * 60) + (Seconds!)
    }
}
extension Date {
    func ShortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
extension TimeInterval {
    func ShortData() -> String {
        return Date.init(timeIntervalSince1970: self).ShortDate()
    }
}
func timeAgoSinceDate(_ date:Date,currentData:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
//let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
       let now = currentData
       let earliest = (now as NSDate).earlierDate(date)
       let latest = (earliest == now ) ? date : now
       let components : DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second ] ,from: earliest,to: latest , options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}
let date = Date(timeIntervalSince1970: 1432233446145.0/1000.0)
extension TimeInterval {
    func GetTimeAgo()->String {
        return timeAgoSinceDate(Date.init(timeIntervalSince1970: self), currentData: Date(), numericDates: true)
    }
}

