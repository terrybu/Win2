//
//  WalkthroughManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/13/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import EAIntroView

private let walkthroughDescription1 = "메인화면에서 Win2 청년부 공동체 최신소식과 이야기들을 확인하세요!"
private let walkthroughDescription2 = "Tap the Hamburger Menu icon in upperleft corner to open the navigation menu"

class WalkthroughManager: NSObject, EAIntroDelegate{
    
    static let sharedInstance = WalkthroughManager()
    
    func displayWalkthroughScreen(view: UIView) {
        let walkthroughVC = UIViewController()
        walkthroughVC.view.frame = view.frame
        let page1 = setUpPageForEAIntroPage(walkthroughVC, title: "Welcome", description: walkthroughDescription1, imageName: "Walkthru-home")
        let page3 = setUpPageForEAIntroPage(walkthroughVC, title: "Welcome", description: walkthroughDescription2, imageName: "walkthru03_phone") ;
        
        let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1, page3])
        //if you want to the navigation bar way
        //let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1,page2,page3,page4])
        introView.delegate = self
        introView.pageControlY = walkthroughVC.view.frame.size.height - 30 - 48 - 64;
        introView.bgImage = UIImage(named: "bg_gradient")
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setBackgroundImage(UIImage(named: "btn_X"), forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 0, 24, 20)
        introView.skipButton = btn
        introView.skipButtonY = walkthroughVC.view.frame.size.height - 30
        introView.skipButtonAlignment = EAViewAlignment.Right
        introView.showInView(walkthroughVC.view, animateDuration: 0.3)
        view.addSubview(introView)
    }
    
    //This was a weird decision. Didn't really need defaults token
//    func redirectToHomeScreenAfterCheckingForFirstLaunch(window: UIWindow?) {
//        let appLaunchToken = NSUserDefaults.standardUserDefaults().boolForKey(kAppLaunchToken)
//        if appLaunchToken == false {
//            print("App was never launched before, setting NSUserDefault AND displaying walkthrough screen")
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kAppLaunchToken)
//            WalkthroughManager.sharedInstance.displayWalkthroughScreen(window)
//        }
//        else if appLaunchToken == true {
//            print("Not first launch because App Token was found. Take him straight to login or home screen without walkthrough")
//            showHomeScreen()
//        }
//    }

    
    private func setUpPageForEAIntroPage(walkthroughVC: UIViewController, title: String, description: String, imageName: String) -> EAIntroPage {
        let page = EAIntroPage()
        page.title = title
        page.titlePositionY = walkthroughVC.view.frame.size.height - 30
        page.titleFont = UIFont(name: "NanumBarunGothic", size: 21.0)
        page.desc = description
        page.descFont = UIFont(name: "NanumBarunGothic", size: 20.0 * 6/8)
        page.descWidth = walkthroughVC.view.frame.size.width * 0.75
        //setting position on these work weirdly. Higher the number, Higher it goes up toward top of screen. Lower the number, more it sticks to bottom of screen
        page.descPositionY = walkthroughVC.view.frame.size.height - 30 - 32
        let walkthroughImageView = UIImageView(image: UIImage(named: imageName))
        page.titleIconView = walkthroughImageView
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS{
            page.titleIconPositionY = walkthroughVC.view.frame.size.height - walkthroughImageView.frame.size.height + 50
        } else {
            page.titleIconPositionY = walkthroughVC.view.frame.size.height - walkthroughImageView.frame.size.height
        }
        return page
    }
    
    //MARK: EAIntroViewDelegate
    @objc func introDidFinish(introView: EAIntroView!) {
        print("intro walkthrough finished")
    }
    
    func showHomeScreen(view: UIView) {
        displayWalkthroughScreen(view)
        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = revealVC
        appDelegate.setUpNavBarAndStatusBarImages()
    }
    
}