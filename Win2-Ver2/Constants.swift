//
//  Constants.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/21/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

//Device OS version and Screen size Type related
let Device = UIDevice.currentDevice()
let iosVersion = NSString(string: Device.systemVersion).doubleValue
let iOS8 = iosVersion >= 8
let iOS7 = iosVersion >= 7 && iosVersion < 8

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

//Other constants
let kOriginalAboutViewHeight: CGFloat = 54

//String Constants
let kAppLaunchToken = "kAppLaunchToken"
let kWeeklyProgramsTableViewCellReuseIdentifier = "WeeklyProgramsTableViewCell"
let kUserDefaultsSavedNoticesArrayData = "kUserDefaultsSavedNoticesArrayData"

//Keys
let kAdminEmailInput = "admin"
let kSocialServicesAdminEmailInput = "social"
let kUserDidLoginBefore = "kUserDidLoginBefore"