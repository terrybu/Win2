//
//  HolyStarIntroViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/20/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class HolyStarIntroViewController: UIViewController {
    
    @IBOutlet var infoTextView: UITextView! 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        ParentViewController.makeNavBarHairLineBarWhiteAndShort(self.navigationController!, view: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
