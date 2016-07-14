//
//  NoticeCreationViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class NoticeCreationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: PaddedTextField!
    @IBOutlet weak var bodyTextField: PaddedTextField!
    @IBOutlet weak var linkTextField: PaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "pressedDoneButton")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func pressedDoneButton() {
        print("press done")
        if let title = titleTextField.text, body = bodyTextField.text, link = linkTextField.text {
            let newNotice = Notice(title: title, body: body, link: link, date: CustomDateFormatter.sharedInstance.returnTodaysDateStringInFormat())
            
            //Push new notice into Firebase
            FirebaseManager.sharedManager.createNewNoticeOnFirebase(newNotice, completion: { (success) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            
        } else {
            UIAlertController.presentAlert(self, alertTitle: "Empty Fields", alertMessage: "Please fill out every field to submit a new Notice", confirmTitle: "OK")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
