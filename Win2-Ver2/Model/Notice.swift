//
//  Notice.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import Foundation

class Notice {
    
    var title: String
    var body: String
    var link: String
    var date: String
    var active = false
    var firebaseID: String?
    
    init(title: String, body: String, link: String, date: String) {
        self.title = title
        self.body = body
        self.link = link
        self.date = date
    }
    
}