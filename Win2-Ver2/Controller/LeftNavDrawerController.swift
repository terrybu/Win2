//
//  LeftNavDrawerController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class LeftNavDrawerController: UIViewController {
    
    //MARK: Properties 
    var purpleStatusBar: UIView!
    var maskView : UIView!
    var aboutVCNavCtrl : UINavigationController?
    var homeVCNavCtrl: UINavigationController?
    var worshipVCNavCtrl: UINavigationController?
    var nurtureVCNavCtrl: UINavigationController?
    var communicationsVCNavCtrl: UINavigationController?
    var evangelismVCNavCtrl: UINavigationController?
    var socialServicesVCNavCtrl: UINavigationController?
    var galleryVCNavCtrl: UINavigationController?
    var swipeGestureRightToLeft: UISwipeGestureRecognizer!
    
    @IBOutlet var logoutButton: UIButton!
    @IBAction func logoutPressed() {
        print("logout")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kUserDidLoginBefore)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = appDelegate.loginVC
    }

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.setBackgroundImage(UIImage(named: "logout")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        logoutButton.tintColor = UIColor.whiteColor()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        purpleStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        purpleStatusBar.backgroundColor = UIColor.In2DeepPurple()
        appDelegate.window?.rootViewController?.view.addSubview(purpleStatusBar)
        
        let homeNavCtrl = self.revealViewController().frontViewController as! UINavigationController
        self.homeVCNavCtrl = homeNavCtrl
        
        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        swipeGestureRightToLeft = UISwipeGestureRecognizer(target: self, action: "userJustSwipedFromRightToLeft:")
        swipeGestureRightToLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeGestureRightToLeft)
    }
    
    override func viewWillAppear(animated: Bool) {
        purpleStatusBar.hidden = false
    }
    
    func userJustSwipedFromRightToLeft(gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == UISwipeGestureRecognizerDirection.Left) {
            print("swiped left")
            purpleStatusBar.hidden = true
            self.revealViewController().revealToggleAnimated(true)
        }
    }
    
    // MARK: IBActions
    @IBAction
    func xButtonPressed(sender: AnyObject) {
        purpleStatusBar.hidden = true
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction
    func worshipButtonPressed(sender: UIButton) {
        if worshipVCNavCtrl == nil {
            worshipVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WorshipNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(worshipVCNavCtrl, animated: true)
    }
    
    @IBAction
    func nurtureButtonPressed(sender: UIButton) {
        if nurtureVCNavCtrl == nil {
            nurtureVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NurtureNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(nurtureVCNavCtrl, animated: true)
    }
    
    @IBAction
    func communicationsButtonPressed(sender: UIButton) {
        if communicationsVCNavCtrl == nil {
            communicationsVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommunicationsNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(communicationsVCNavCtrl, animated: true)
    }
    
    @IBAction
    func evangelismButtonPressed(sender: UIButton) {
        if evangelismVCNavCtrl == nil {
            evangelismVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EvangelismNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(evangelismVCNavCtrl, animated: true)
    }
    
    @IBAction
    func socialServicesButtonPressed(sender: UIButton) {
        if socialServicesVCNavCtrl == nil {
            socialServicesVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialServicesNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(socialServicesVCNavCtrl, animated: true)
    }
    
    @IBAction
    func galleryButtonPressed(sender: UIButton) {
        if galleryVCNavCtrl == nil {
            galleryVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GalleryNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(galleryVCNavCtrl, animated: true)
    }
    
    @IBAction
    func aboutPIButtonPressed(sender: UIButton) {
        if aboutVCNavCtrl == nil {
            aboutVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutVCNavCtrl") as? UINavigationController
            
            //TODO: I was trying to refactor out About VC to its own XIB but it didn't work below because the frames got all messed up and misaligned 
//            let aboutVC = AboutPIViewController()
//            aboutVCNavCtrl = UINavigationController(rootViewController: aboutVC)
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(aboutVCNavCtrl, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
