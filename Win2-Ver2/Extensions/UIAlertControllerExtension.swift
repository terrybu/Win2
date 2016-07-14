//
//  UIAlertControllerExtension.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func presentAlert(viewController: UIViewController, alertTitle: String, alertMessage: String, confirmTitle: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let confirm = UIAlertAction(title: confirmTitle, style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(confirm)
        viewController.presentViewController(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.In2DeepPurple()
    }
    
}