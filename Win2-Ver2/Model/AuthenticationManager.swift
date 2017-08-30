//
//  AuthenticationManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import Foundation

enum UserMode {
    case user, admin, socialServicesAdmin
}

class AuthenticationManager {
    
    static let sharedManager = AuthenticationManager()
    var currentUserMode = UserMode.user //default is just plain User
    
}
