//
//  CustomDateFormatter.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/16/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

class CustomDateFormatter {
    
    static let sharedInstance = CustomDateFormatter()
    let dateFormatter = DateFormatter()
    
    func convertDateTimeToFirebaseStringFormat(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func convertDateToFirebaseStringFormat(_ date: Date) -> String {
        self.dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func returnTodaysDateStringInFormat() -> String {
        self.dateFormatter.dateFormat = "MM/dd/yyyy"
        let today = dateFormatter.string(from: Date())
        return today
    }
    
    func convertFBCreatedTimeDateToOurFormattedString(_ feedObject: FBFeedPost) -> String? {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let date = dateFormatter.date(from: feedObject.created_time)
        if let date = date {
            dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}
