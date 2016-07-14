//
//  AuthenticationManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import Foundation

enum UserMode {
    case User, Admin, SocialServicesAdmin
}

class AuthenticationManager {
    
    static let sharedManager = AuthenticationManager()
    var currentUserMode = UserMode.User //default is just plain User
    
}