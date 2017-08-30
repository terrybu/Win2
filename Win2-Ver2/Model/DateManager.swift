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
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = (calendar as NSCalendar).components([.day , .month , .year], from: today)
        let thisMonth = todayComponents.month //this will give you today's month
        return thisMonth!
    }
    
    func getTodaysYear() -> Int {
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = (calendar as NSCalendar).components([.day , .month , .year], from: today)
        let thisYear = todayComponents.year //this will give you today's month
        return thisYear!
    }
    
    
}
