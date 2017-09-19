//
//  SocialServicesViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class SocialServicesViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource{

    fileprivate var expandedAboutViewHeight: CGFloat = 0
    fileprivate let kOriginalContentViewHeight: CGFloat = 700
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet var socialNewsWidgetView: BoroSpecificNewsWidgetView!
    var socialFeedPost: FBFeedPost?
    
    @IBOutlet var tableView: UITableView!
    var eventsArray: [SocialServiceEvent]?
    
    
    @IBAction func applyButtonPressed() {
        self.presentSFSafariVCIfAvailable(URL(string: kApplySocialServicesTeamGoogleDocURL)!)
        
    }
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView(kOriginalAboutViewHeight, expandableAboutView: expandableAboutView, heightBuffer: 20, view: view, constraintHeightExpandableView: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalContentviewHeight: kOriginalContentViewHeight)
        
        for feedObject in FacebookFeedQuery.sharedInstance.FBFeedObjectsArray {
            if let parsed = feedObject.parsedCategory {
                if parsed.contains(kSocialServicesTag) {
                    socialFeedPost = feedObject
                    socialNewsWidgetView.title = feedObject.parsedTitle
                    socialNewsWidgetView.dateLabel.text = feedObject.parsedDate
                    socialNewsWidgetView.viewMoreButton.addTarget(self, action: #selector(SocialServicesViewController.viewMoreButtonWasPressed), for: UIControlEvents.touchUpInside)
                    break
                }
            }
        }
        if socialFeedPost == nil {
            socialNewsWidgetView.title = "최근 긍휼부 뉴스가 존재하지 않습니다."
            socialNewsWidgetView.dateLabel.text = nil
        }
    }
    
    @objc
    fileprivate func viewMoreButtonWasPressed() {
        if let feedObject = socialFeedPost {
            FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = CGPoint(x: view.center.x, y: 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        FirebaseManager.sharedManager.getServiceEventObjectsFromFirebase({
            (success) -> Void in
            if (success) {
                self.eventsArray = FirebaseManager.sharedManager.eventsArray
                self.tableView.reloadData()
            }
            activityIndicator.stopAnimating()
        })
    }
    
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventsArray = eventsArray {
            return eventsArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuse")
        
        let event = eventsArray![indexPath.row]
        cell.textLabel!.text = event.title
        cell.detailTextLabel!.text = event.date

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 12, y: 5, width: 300, height: 18))
        label.text = "긍휼부 이벤트 리스트"
        headerView.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsArray![indexPath.row]
        UIAlertController.presentAlert(self, alertTitle: event.title, alertMessage: "날짜: \(event.date) \nTeam: \(event.teamName)\n\n \(event.description)", confirmTitle: "OK")
    }

    
    //Allowing storyboard to load this VC from XIB
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
