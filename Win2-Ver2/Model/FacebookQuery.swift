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
    
    func getFBDataJSON(_ graphPathString: String, params: [String: String], onSuccess: ((_ data: JSON) -> Void)?, onError: ((_ error: NSError?) -> Void)?)  {
        FBSDKGraphRequest(graphPath: graphPathString, parameters: params).start { (connection, data, error) -> Void in
            if (error == nil) {
                if let onSuccess = onSuccess {
                    onSuccess(JSON(data))
                }
            } else {
                if let onError = onError {
                    onError(error as! NSError)
                }
            }
        }
    }


}
