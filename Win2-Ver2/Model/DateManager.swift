//
//  DateManager.swift
//  
//
//  Created by Terry Bu on 1/16/16.
//
//

import Foundation

class DateManager {
    
    static let sharedInstance = DateManager()
    
    //Get today's month as Int
    func getTodaysMonth() -> Int {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let todayComponents = calendar.components([.Day , .Month , .Year], fromDate: today)
        let thisMonth = todayComponents.month //this will give you today's month
        return thisMonth
    }
    
    func getTodaysYear() -> Int {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let todayComponents = calendar.components([.Day , .Month , .Year], fromDate: today)
        let thisYear = todayComponents.year //this will give you today's month
        return thisYear
    }
    
    
}