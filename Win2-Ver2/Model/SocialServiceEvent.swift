//
//  SocialServiceEvent.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import Foundation

class SocialServiceEvent {
    
    var title: String
    var teamName: String
    var description: String
    var date: String
    var firebaseID: String?
    
    init(title: String, teamName: String, description: String, date: String) {
        self.title = title
        self.teamName = teamName
        self.description = description
        self.date = date
    }
    
}