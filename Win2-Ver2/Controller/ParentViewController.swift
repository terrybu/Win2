//
//  ParentViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices

class ParentViewController: UIViewController, SFSafariViewControllerDelegate {
    
    func hamburgerPressed(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
    }

    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
    class func makeNavBarHairLineBarWhiteAndShort(navController: UINavigationController, view: UIView) {
        navController.navigationBar.shadowImage = UIImage()
        let whiteHairLineCustom = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        whiteHairLineCustom.backgroundColor = UIColor.whiteColor()
        whiteHairLineCustom.alpha = 0.5
        view.addSubview(whiteHairLineCustom)
    }
    
    func setUpStandardUIForViewControllers() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        ParentViewController.makeNavBarHairLineBarWhiteAndShort(self.navigationController!, view: view)
        
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        navigationItem.leftBarButtonItem = hamburger
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("homeButtonPressed"))
        navigationItem.rightBarButtonItem = homeButton
    }
    
    func setUpLeftNavDrawerMenuWidth() {
        if let revealVC = self.revealViewController() {
            revealVC.rearViewRevealWidth = self.view.frame.size.width
        }
    }
    
    
    func setUpExpandableAboutView(originalAboutViewHeight: CGFloat, expandableAboutView: ExpandableAboutView, heightBuffer: CGFloat, view: UIView, constraintHeightExpandableView: NSLayoutConstraint, constraintContentViewHeight: NSLayoutConstraint, originalContentviewHeight: CGFloat) {
        let expandedAboutViewHeight = originalAboutViewHeight + expandableAboutView.textView.frame.size.height + heightBuffer
        expandableAboutView.clipsToBounds = true
        let handler = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: originalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: originalContentviewHeight)
        expandableAboutView.handler = handler
        makeExpandableAboutViewTappable(expandableAboutView, handler: handler)
    }
    
    func makeExpandableAboutViewTappable(expandableView: ExpandableAboutView, handler: ExpandableAboutViewHandler) {
        expandableView.handler = handler
        expandableView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: handler, action: "tappedEntireAboutView")
        expandableView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = handler
        //also add the function to the arrow button
        expandableView.arrowImageButton.addTarget(handler, action: "tappedEntireAboutView", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func presentSFSafariVCIfAvailable(url: NSURL) {
        let sfVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
        sfVC.delegate = self
        self.presentViewController(sfVC, animated: true, completion: nil)
        //in case anybody prefers right to left push viewcontroller animation transition (below)
        //navigationController?.pushViewController(sfVC, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        setUpLeftNavDrawerMenuWidth()
    }
    
    
}
