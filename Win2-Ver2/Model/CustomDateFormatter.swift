//
//  CustomDateFormatter.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/16/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

class CustomDateFormatter {
    
    static let sharedInstance = CustomDateFormatter()
    let dateFormatter = NSDateFormatter()
    
    func convertDateTimeToFirebaseStringFormat(date: NSDate) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func convertDateToFirebaseStringFormat(date: NSDate) -> String {
        self.dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    func returnTodaysDateStringInFormat() -> String {
        self.dateFormatter.dateFormat = "MM/dd/yyyy"
        let today = dateFormatter.stringFromDate(NSDate())
        return today
    }
    
    func convertFBCreatedTimeDateToOurFormattedString(feedObject: FBFeedPost) -> String? {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let date = dateFormatter.dateFromString(feedObject.created_time)
        if let date = date {
            dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
            return dateFormatter.stringFromDate(date)
        }
        return nil
    }
    
}