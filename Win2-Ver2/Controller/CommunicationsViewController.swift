//
//  CommunicationsViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import AFNetworking

private let kCommunicationsTableViewCellIdentifier = "CommunicationsTableViewCell"

class CommunicationsViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    @IBOutlet var tableView: UITableView!
    var feedObjectsArray: [FBFeedPost]?
    
    //For expandable view
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    
    var cache = NSCache<AnyObject, AnyObject>()
    var operationManager: AFHTTPSessionManager?
    var expandedAboutViewHeight:CGFloat = 0

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        tableView.register(UINib(nibName: "CommunicationsTableViewCell", bundle: nil), forCellReuseIdentifier: kCommunicationsTableViewCellIdentifier)
        self.feedObjectsArray = FacebookFeedQuery.sharedInstance.FBFeedObjectsArray
        
        setUpExpandableAboutView()
        
        operationManager = AFHTTPSessionManager()
        operationManager!.responseSerializer = AFImageResponseSerializer()
    }
    
    //MARK: ExpandableAboutViewDelegate
    fileprivate func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height + 70
        expandableAboutView.clipsToBounds = true
        expandableAboutView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommunicationsViewController.tappedEntireAboutView))
        expandableAboutView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        expandableAboutView.arrowImageButton.addTarget(self, action: #selector(CommunicationsViewController.tappedEntireAboutView), for: UIControlEvents.touchUpInside)
        
        expandableAboutView.textView.dataDetectorTypes = .link
        expandableAboutView.textView.isEditable = false
        expandableAboutView.textView.text = "   \"그리스도로부터 온몸이 각 마디를 통해 함께 연결되고 결합됩니다. 각 지체가 맡은 분량대로 기능하는 가운데 그 몸을 자라게 하며 사랑 가운데 스스로를 세워갑니다.\" -에베소서 4:16 \n\n   파이매거진, 앱&웹팀, 광고&기획팀이 속한 소통보로는 예수님의 사랑을 서로서로 소통하는 공동체를 만들기 위해 힘씁니다. \n\n   소통부 사역 신청서: \(kApplyCommunicationsTeamGoogleDocURL)"
    }
    
    func tappedEntireAboutView() {
        if !expandableAboutView.expanded {            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.constraintHeightExpandableView.constant = self.expandedAboutViewHeight
                self.view.layoutIfNeeded()
                self.expandableAboutView.expanded = true

                }, completion: { (completed) -> Void in
            }) 
        }
        else {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.expandableAboutView.expanded = false
                self.constraintHeightExpandableView.constant = kOriginalAboutViewHeight
                self.view.layoutIfNeeded()
                }, completion: { (completed) -> Void in
            }) 
        }
        
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedObjectsArray = self.feedObjectsArray else {
            return 0
        }
        return feedObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCommunicationsTableViewCellIdentifier, for: indexPath) as? CommunicationsTableViewCell
        if cell == nil {
            cell = CommunicationsTableViewCell()
        }
        
        cell!.tag = indexPath.row
        configureCell(cell!, indexPath: indexPath)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CommunicationsViewController.tappedCell(_:)))
        cell!.isUserInteractionEnabled = true
        cell!.addGestureRecognizer(tap)
        
        return cell!
    }
    
    func configureCell(_ cell: CommunicationsTableViewCell, indexPath: IndexPath) {
        let feedObject = feedObjectsArray![indexPath.row]
        cell.categoryLabel.text = feedObject.parsedCategory
        cell.titleLabel.text = feedObject.parsedTitle
        cell.dateLabel.text = feedObject.parsedDate

        if feedObject.type == "photo" {
            if cache.object(forKey: "\(indexPath.row)" as AnyObject) != nil{
                let img = cache.object(forKey: "\(indexPath.row)" as AnyObject) as! UIImage
                cell.backgroundImageView.image = img
                
            } else {
                cell.backgroundImageView.image = nil
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                activityIndicator.center = view.center
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringForCommunicationsFrom(feedObject.id, completion: { (normImgUrlString) -> Void in
                    self.operationManager!.get(normImgUrlString, parameters: nil, success: { (operation, responseObject) -> Void in
                        //success
                        activityIndicator.stopAnimating()

                        if cell.tag == indexPath.row {
                            self.cache.setObject(responseObject! as AnyObject, forKey: "\(indexPath.row)" as AnyObject)
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.tableView .reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            })
                        }
                    }, failure: {
                        (operation, error) -> Void in
                            print(error)
                            DispatchQueue.main.async(execute: { () -> Void in
                                activityIndicator.stopAnimating()
                            })
                        }
                    )
                })
            }
        } else {
            cell.backgroundImageView.image = UIImage(named:"sampleGray")
        }
    }
    
    func tappedCell(_ sender: UIGestureRecognizer) {
        //postURL has to nick out the second part of the _ string from firstObjectID
        let i = sender.view?.tag
        let feedObject = feedObjectsArray![i!]
        FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedArticle = feedObjectsArray![indexPath.row] as FBFeedPost
        print(feedArticle)
    }
    
    //Allowing storyboard to load this VC from XIB
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
