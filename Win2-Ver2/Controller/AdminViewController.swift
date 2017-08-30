//
//  AdminViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var socialServicesScheduleButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIForNavBarAndStatus()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_X"), style: UIBarButtonItemStyle.done, target: self, action: #selector(AdminViewController.dismissVC))
        self.navigationItem.leftBarButtonItem = backButton
        
        if AuthenticationManager.sharedManager.currentUserMode == .socialServicesAdmin {
            noticeButton.isEnabled = false
        } else {
            noticeButton.isEnabled = true
        }
    }
    
    func dismissVC() {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    fileprivate func setUpUIForNavBarAndStatus() {
        self.title = "Admin Mode"
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBarBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        navigationController!.view.addSubview(statusBarBackgroundView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_bar"), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "NanumBarunGothic", size: 18.0)!
        ]
        navigationController!.navigationBar.shadowImage = UIImage()
        let whiteHairLineCustom = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.5))
        whiteHairLineCustom.backgroundColor = UIColor.white
        whiteHairLineCustom.alpha = 0.5
        view.addSubview(whiteHairLineCustom)
    }
    
    
    @IBAction func noticeButtonPressed(_ sender: AnyObject) {
        let noticeVC = NoticeAdminViewController()
        self.navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    
    @IBAction func socialServicesSchedulePressed(_ sender: AnyObject) {
        let socialServiceEventAdminVC = SocialServicesEventAdminTableViewController()
        self.navigationController?.pushViewController(socialServiceEventAdminVC, animated: true)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
