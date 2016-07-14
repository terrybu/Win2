//
//  FacebookQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/8/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FacebookQuery {
    
    func getFBDataJSON(graphPathString: String, params: [String: String], onSuccess: ((data: JSON) -> Void)?, onError: ((error: NSError!) -> Void)?)  {
        FBSDKGraphRequest(graphPath: graphPathString, parameters: params).startWithCompletionHandler { (connection, data, error) -> Void in
            if (error == nil) {
                if let onSuccess = onSuccess {
                    onSuccess(data: JSON(data))
                }
            } else {
                if let onError = onError {
                    onError(error: error)
                }
            }
        }
    }


}