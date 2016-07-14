//
//  FBFeedPost.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation

class FBFeedPost {
    
    var id: String
    var message: String
    var created_time: String
    var type: String
    var parsedTitle: String?
    var parsedCategory: String?
    var parsedDate: String?
    
    init(id: String, message: String, created_time: String, type: String) {
        self.id = id
        self.message = message
        self.created_time = created_time
        self.type = type
    }
    
}