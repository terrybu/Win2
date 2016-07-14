//
//  EvangelismViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EvangelismViewController: ParentViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    var expandedAboutViewHeight:CGFloat = 0
    private let kOriginalContentViewHeight: CGFloat = 600
    
    var evangelismFeedObject: FBFeedPost?
    @IBOutlet var evangelismNewsWidgetView: BoroSpecificNewsWidgetView!
    @IBOutlet var evangelismImageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView(kOriginalAboutViewHeight, expandableAboutView: expandableAboutView, heightBuffer: 30, view: view, constraintHeightExpandableView: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalContentviewHeight: kOriginalContentViewHeight)
        
        for feedObject in FacebookFeedQuery.sharedInstance.FBFeedObjectsArray {
            if feedObject.parsedCategory == kEvangelismTag {
                evangelismFeedObject = feedObject
                evangelismNewsWidgetView.title = feedObject.parsedTitle
                evangelismNewsWidgetView.dateLabel.text = feedObject.parsedDate
                evangelismNewsWidgetView.viewMoreButton.addTarget(self, action: "viewMoreButtonWasPressedForEvangelismNews", forControlEvents: UIControlEvents.TouchUpInside)
                break
            }
        }
        if evangelismFeedObject == nil {
            evangelismNewsWidgetView.title = "최근 선교뉴스가 존재하지 않습니다."
            evangelismNewsWidgetView.dateLabel.text = nil
        }
        
        evangelismImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "playVideo")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        evangelismImageView.addGestureRecognizer(tapGesture)
        playButton.addTarget(self, action: "playVideo", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func playVideo()  {
         let path = NSBundle.mainBundle().pathForResource("phillyMission", ofType:"mp4")
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
    @objc
    private func viewMoreButtonWasPressedForEvangelismNews() {
        if let feedObject = evangelismFeedObject {
            FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
        }
    }
    
    //Allowing storyboard to load this VC from XIB
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}