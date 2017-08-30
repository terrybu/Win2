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
        UserDefaults.standard.removeObject(forKey: kUserDidLoginBefore)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = appDelegate.loginVC
    }

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.setBackgroundImage(UIImage(named: "logout")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        logoutButton.tintColor = UIColor.white
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        purpleStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        purpleStatusBar.backgroundColor = UIColor.In2DeepPurple()
        appDelegate.window?.rootViewController?.view.addSubview(purpleStatusBar)
        
        let homeNavCtrl = self.revealViewController().frontViewController as! UINavigationController
        self.homeVCNavCtrl = homeNavCtrl
        
        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        swipeGestureRightToLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeftNavDrawerController.userJustSwipedFromRightToLeft(_:)))
        swipeGestureRightToLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeGestureRightToLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        purpleStatusBar.isHidden = false
    }
    
    func userJustSwipedFromRightToLeft(_ gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == UISwipeGestureRecognizerDirection.left) {
            print("swiped left")
            purpleStatusBar.isHidden = true
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    // MARK: IBActions
    @IBAction
    func xButtonPressed(_ sender: AnyObject) {
        purpleStatusBar.isHidden = true
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction
    func worshipButtonPressed(_ sender: UIButton) {
        if worshipVCNavCtrl == nil {
            worshipVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorshipNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(worshipVCNavCtrl, animated: true)
    }
    
    @IBAction
    func nurtureButtonPressed(_ sender: UIButton) {
        if nurtureVCNavCtrl == nil {
            nurtureVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NurtureNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(nurtureVCNavCtrl, animated: true)
    }
    
    @IBAction
    func communicationsButtonPressed(_ sender: UIButton) {
        if communicationsVCNavCtrl == nil {
            communicationsVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunicationsNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(communicationsVCNavCtrl, animated: true)
    }
    
    @IBAction
    func evangelismButtonPressed(_ sender: UIButton) {
        if evangelismVCNavCtrl == nil {
            evangelismVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EvangelismNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(evangelismVCNavCtrl, animated: true)
    }
    
    @IBAction
    func socialServicesButtonPressed(_ sender: UIButton) {
        if socialServicesVCNavCtrl == nil {
            socialServicesVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SocialServicesNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(socialServicesVCNavCtrl, animated: true)
    }
    
    @IBAction
    func galleryButtonPressed(_ sender: UIButton) {
        if galleryVCNavCtrl == nil {
            galleryVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryNavController") as? UINavigationController
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(galleryVCNavCtrl, animated: true)
    }
    
    @IBAction
    func aboutPIButtonPressed(_ sender: UIButton) {
        if aboutVCNavCtrl == nil {
            aboutVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVCNavCtrl") as? UINavigationController
            
            //TODO: I was trying to refactor out About VC to its own XIB but it didn't work below because the frames got all messed up and misaligned 
//            let aboutVC = AboutPIViewController()
//            aboutVCNavCtrl = UINavigationController(rootViewController: aboutVC)
        }
        purpleStatusBar.isHidden = true
        revealViewController().pushFrontViewController(aboutVCNavCtrl, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
