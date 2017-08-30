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
    
    func hamburgerPressed(_ sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
    }

    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
    class func makeNavBarHairLineBarWhiteAndShort(_ navController: UINavigationController, view: UIView) {
        navController.navigationBar.shadowImage = UIImage()
        let whiteHairLineCustom = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        whiteHairLineCustom.backgroundColor = UIColor.white
        whiteHairLineCustom.alpha = 0.5
        view.addSubview(whiteHairLineCustom)
    }
    
    func setUpStandardUIForViewControllers() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        ParentViewController.makeNavBarHairLineBarWhiteAndShort(self.navigationController!, view: view)
        
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.done, target: self, action: #selector(ParentViewController.hamburgerPressed(_:)))
        navigationItem.leftBarButtonItem = hamburger
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ParentViewController.homeButtonPressed))
        navigationItem.rightBarButtonItem = homeButton
    }
    
    func setUpLeftNavDrawerMenuWidth() {
        if let revealVC = self.revealViewController() {
            revealVC.rearViewRevealWidth = self.view.frame.size.width
        }
    }
    
    
    func setUpExpandableAboutView(_ originalAboutViewHeight: CGFloat, expandableAboutView: ExpandableAboutView, heightBuffer: CGFloat, view: UIView, constraintHeightExpandableView: NSLayoutConstraint, constraintContentViewHeight: NSLayoutConstraint, originalContentviewHeight: CGFloat) {
        let expandedAboutViewHeight = originalAboutViewHeight + expandableAboutView.textView.frame.size.height + heightBuffer
        expandableAboutView.clipsToBounds = true
        let handler = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: originalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: originalContentviewHeight)
        expandableAboutView.handler = handler
        makeExpandableAboutViewTappable(expandableAboutView, handler: handler)
    }
    
    func makeExpandableAboutViewTappable(_ expandableView: ExpandableAboutView, handler: ExpandableAboutViewHandler) {
        expandableView.handler = handler
        expandableView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: handler, action: "tappedEntireAboutView")
        expandableView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = handler
        //also add the function to the arrow button
        expandableView.arrowImageButton.addTarget(handler, action: "tappedEntireAboutView", for: UIControlEvents.touchUpInside)
    }
    
    func presentSFSafariVCIfAvailable(_ url: URL) {
        let sfVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        sfVC.delegate = self
        self.present(sfVC, animated: true, completion: nil)
        //in case anybody prefers right to left push viewcontroller animation transition (below)
        //navigationController?.pushViewController(sfVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpLeftNavDrawerMenuWidth()
    }
    
    
}
