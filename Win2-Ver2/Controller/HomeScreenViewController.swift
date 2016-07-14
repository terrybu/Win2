//
//  HomeScreenViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeScreenViewController: ParentViewController, FacebookFeedQueryDelegate {
    
    // MARK: Properties
    var black: UIView!
    var firstObjectID: String!
    var imageBlackOverlay: UIView?
    @IBOutlet weak var newsArticleView: NewsArticleView!
    @IBOutlet weak var noticeWidget: NoticeWidget!
    var activeNotice: Notice?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let smallLogoView = UIImageView(image: UIImage(named: "WINTO_logo_small"))
        self.navigationItem.titleView = smallLogoView
        
        setUpUniqueUIForHomeVC()
        blackOverlayAndLoadingSpinnerUntilFBDataFinishedLoading()
        FacebookFeedQuery.sharedInstance.delegate = self
        FacebookFeedQuery.sharedInstance.getFeedFromPIMagazine { (error) -> Void in
            if error != nil {
                print(error.description)
                self.activityIndicator.stopAnimating()
            }
        }
        FirebaseManager.sharedManager.getNoticeObjectsFromFirebase({ (success) -> Void in
            if success {
                self.activeNotice = FirebaseManager.sharedManager.activeNotice!
                self.noticeWidget.body = self.activeNotice!.title
                self.noticeWidget.viewMoreNoticeButton.addTarget(self, action: "viewMoreNotice", forControlEvents: UIControlEvents.TouchUpInside)
            }
        })
    }
    
    
    func viewMoreNotice() {
        if activeNotice?.link != "" {
            UIAlertController.presentAlert(self, alertTitle: activeNotice!.title, alertMessage: "날짜: \(activeNotice!.date)\n\n  \(activeNotice!.body) \n\n Link: \(activeNotice!.link)", confirmTitle: "OK")
        } else {
            UIAlertController.presentAlert(self, alertTitle: activeNotice!.title, alertMessage: "날짜: \(activeNotice!.date)\n\n  \(activeNotice!.body)", confirmTitle: "OK")
        }
    }
    
    private func setUpUniqueUIForHomeVC() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_bar"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        navigationItem.leftBarButtonItem = hamburger
    }
    
    private func blackOverlayAndLoadingSpinnerUntilFBDataFinishedLoading() {
        black = UIView(frame: view.frame)
        black.backgroundColor = UIColor.blackColor()
        view.addSubview(black)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func tappedNewsArticleView(sender: UIGestureRecognizer) {
        print(firstObjectID)
        //postURL has to nick out the second part of the _ string from firstObjectID
        let postURLParam = firstObjectID.componentsSeparatedByString("_").last
        let postURL = "\(kFacebookPageURL)\(postURLParam!)"
        let wkWebView = UIWebView(frame: self.view.frame)
        wkWebView.loadRequest(NSURLRequest(URL: NSURL(string: postURL)!))
        let emptyVC = UIViewController()
        emptyVC.view = wkWebView
        navigationController?.pushViewController(emptyVC, animated: true)
    }
    
    //MARK: FacebookFeedQueryDelegate 
    func didFinishGettingFacebookFeedData(fbFeedObjectArray: [FBFeedPost]) {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedNewsArticleView:"))
        newsArticleView.userInteractionEnabled = true
        newsArticleView.addGestureRecognizer(tapGesture)
        
        let firstObject = fbFeedObjectArray[0]
        newsArticleView.categoryLabel.text = firstObject.parsedCategory
        newsArticleView.titleLabel.text = firstObject.parsedTitle
        newsArticleView.dateLabel.text = firstObject.parsedDate
        firstObjectID = firstObject.id
        if firstObject.type == "photo" {
            FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringForCommunicationsFrom(firstObject.id, completion: { (normImgUrlString) -> Void in
                    self.newsArticleView.backgroundImageView.setImageWithURL(NSURL(string: normImgUrlString)!)
                self.black.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
