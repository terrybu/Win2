//
//  WeeklyProgramDisplayManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/26/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeeklyProgramDisplayManager {
    
    static let sharedInstance = WeeklyProgramDisplayManager()
    
    func displayWeeklyProgramLogic(weeklyProgram: WeeklyProgram, view: UIView, navController: UINavigationController, viewController: UIViewController) {
        if weeklyProgram.cached  {
            WeeklyProgramDisplayManager.sharedInstance.displayPDFInWebView(NSURL.fileURLWithPath(weeklyProgram.cachedPath!), view: view, navController: navController)
        } else {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            print(weeklyProgram.pdfDownloadLinkPageOnnuriOrgURL)
            //weeklyProgram.pdfDownloadURL has the PAGE on vision.onnuri.org that contains the link to the PDF.
            //a weeklyProgram object from our weeklyprogramsArray is retrieved from import.io scraper I made that just searches for a list of URLs to hit to get to the LINK page
            
            let pdfdownloadURLString = WeeklyProgramDownloader.sharedInstance.getURLStringForSingleProgramDownload(weeklyProgram.pdfDownloadLinkPageOnnuriOrgURL)
            if let pdfdownloadURLString = pdfdownloadURLString {
                let url = NSURL(string:pdfdownloadURLString)
                HttpFileDownloader.sharedInstance.loadFileAsync(url!, completion:{(path:String, error:NSError!) in
                    if error == nil {
                        weeklyProgram.cached = true
                        weeklyProgram.cachedPath = path
                        let fileURL = NSURL.fileURLWithPath(path)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            MBProgressHUD.hideAllHUDsForView(view, animated: true)
                            WeeklyProgramDisplayManager.sharedInstance.displayPDFInWebView(fileURL, view: view, navController: navController)
                        })
                    } else if error.code == 404 {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            MBProgressHUD.hideAllHUDsForView(view, animated: true)
                            let alertController = UIAlertController(title: "Downloading Problem", message: "Oops! Looks like that file is not available right now :(", preferredStyle: UIAlertControllerStyle.Alert)
                            let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                            alertController.addAction(okay)
                            viewController.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    
    func displayPDFInWebView(fileURL: NSURL, view: UIView, navController: UINavigationController ) {
        let webView = UIWebView(frame: view.frame)
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: fileURL))
        let vc = UIViewController()
        vc.view = webView
        navController.pushViewController(vc, animated: true)
    }
    
    
}