//
//  AppDelegate.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var statusBarBackgroundView: UIView?
    var revealVCView: UIView!
    var loginVC = LoginViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        loginVC.dismissBlock = {
            self.showHomeScreenOnWindow()
        }
        
        if userDidLoginSuccessfullyAlreadyBefore() {
            showHomeScreenOnWindow()
        } else {
            window?.rootViewController = loginVC
        }

        //for status bar text making it white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    fileprivate func showHomeScreenOnWindow() {
        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.window?.rootViewController = revealVC
        self.setUpNavBarAndStatusBarImages()
    }
    
    fileprivate func userDidLoginSuccessfullyAlreadyBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: kUserDidLoginBefore)
    }
    
    func setUpNavBarAndStatusBarImages() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation_bar"), for: UIBarMetrics.default)
        statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBarBackgroundView!.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        window?.rootViewController?.view.addSubview(statusBarBackgroundView!)
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

