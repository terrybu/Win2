//
//  NurtureViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class NurtureViewController: ParentViewController, UIGestureRecognizerDelegate{

    private let kOriginalContentViewHeight: CGFloat = 600
    var expandedAboutViewHeight:CGFloat = 0
    var nurtureFeedObject: FBFeedPost? 
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftNurtureApplyWidget: ApplyWidgetView!
    @IBOutlet weak var rightHolyStarApplyWidget: ApplyWidgetView!
    @IBOutlet weak var nurtureNewsWidget: BoroSpecificNewsWidgetView!


    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView(kOriginalAboutViewHeight, expandableAboutView: expandableAboutView, heightBuffer: 0, view: view, constraintHeightExpandableView: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalContentviewHeight: kOriginalContentViewHeight)
        
        leftNurtureApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.presentSFSafariVCIfAvailable(NSURL(string: kApplyNurtureTeamGoogleDocURL)!)
        }
        rightHolyStarApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.openHolyStarIntroViewController()
        }
        for feedObject in FacebookFeedQuery.sharedInstance.FBFeedObjectsArray {
            if feedObject.parsedCategory == kNurtureTag {
                nurtureFeedObject = feedObject
                nurtureNewsWidget.title = feedObject.parsedTitle
                nurtureNewsWidget.dateLabel.text = feedObject.parsedDate
                nurtureNewsWidget.viewMoreButton.addTarget(self, action: "viewMoreButtonWasPressedForNurtureNews", forControlEvents: UIControlEvents.TouchUpInside)
                break
            }
        }
        guard let nurtureFeedObject = nurtureFeedObject else {
            nurtureNewsWidget.title = "최근 양육뉴스가 존재하지 않습니다."
            nurtureNewsWidget.dateLabel.text = nil
            return
        }
    }
    
    @objc
    private func viewMoreButtonWasPressedForNurtureNews() {
        if let feedObject = nurtureFeedObject {
            FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
        }
    }

    private func openHolyStarIntroViewController() {
        let holyStarVC = HolyStarIntroViewController(nibName: "HolyStarIntroViewController", bundle: nil)
        holyStarVC.title = "홀리스타"
        self.navigationController?.pushViewController(holyStarVC, animated: true)
    }

    //Allowing storyboard to load this VC from XIB
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

}
