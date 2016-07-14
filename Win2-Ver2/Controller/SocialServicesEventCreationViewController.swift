//
//  SocialServicesEventCreationViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class SocialServicesEventCreationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var eventTitle: PaddedTextField!
    @IBOutlet weak var eventTeamName: PaddedTextField!
    @IBOutlet weak var eventDescriptionTextview: UITextView!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "pressedDoneButton")
        self.navigationItem.rightBarButtonItem = doneButton
        
        eventDescriptionTextview.layer.borderWidth = 1.5
        eventDescriptionTextview.layer.borderColor = UIColor(rgba: "#BBBCBC").CGColor
    }
    
    func pressedDoneButton() {
        print("pressed done")
        //firebase logic
        let newEvent = SocialServiceEvent(title: eventTitle.text!, teamName: eventTeamName.text!, description: eventDescriptionTextview.text!, date: CustomDateFormatter.sharedInstance.convertDateTimeToFirebaseStringFormat(eventDatePicker.date))
        FirebaseManager.sharedManager.createNewSocialServiceEventOnFirebase(newEvent) { (success) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate Methods
    
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
        self.eventDescriptionTextview.endEditing(true)
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
