//
//  SignUpViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/15/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var firstNameTextField:PaddedTextField!
    @IBOutlet var lastNameTextField:PaddedTextField!
    @IBOutlet var passwordTextField:PaddedTextField!
    @IBOutlet var confirmPasswordTextField:PaddedTextField!
    @IBOutlet var emailTextField:PaddedTextField!
    
    @IBOutlet var birthdaySwitch: UISwitch!
    @IBOutlet var birthdayDatePicker: UIDatePicker!

    convenience init() {
        self.init(nibName: "SignUpViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        
        birthdayDatePicker.isHidden = true
        birthdayDatePicker.alpha = 0

        birthdaySwitch.addTarget(self, action: #selector(SignUpViewController.switchTurnedOn(_:)), for: UIControlEvents.valueChanged)
        
        setUpUI()
    }
    
    func switchTurnedOn(_ sender: UISwitch) {
        if sender.isOn == true {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.birthdayDatePicker.isHidden = false
                self.birthdayDatePicker.alpha = 1.0

                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.birthdayDatePicker.isHidden = true
                self.birthdayDatePicker.alpha = 0
                }, completion: nil)
        }
    }
    
    fileprivate func setUpUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarSignUp"), for: UIBarMetrics.default)
        //for the longest time, I was wondering why sometimes navigation bar background would look a little lighter than the statusbar backround that Jin made me ... it was because they make it damn translucent by default
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBarBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        navigationController!.view.addSubview(statusBarBackgroundView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_bar"), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignUpViewController.backButtonPressed))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let password = self.passwordTextField.text
        let confirmationPassword = self.confirmPasswordTextField.text
        let email = self.emailTextField.text
        
        if validatedUserInputInTextFields(firstName, lastName: lastName, password: password, confirmationPassword: confirmationPassword, email: email, viewController: self) == false {
            return
            //stop any New User Creation because it didn't pass validation
        }
        
        if birthdaySwitch.isOn {
            createNewUserOnFirebaseAndDirectToHomeScreen(email!, password: password!, firstName: firstName!, lastName: lastName!, birthday: self.birthdayDatePicker.date)
        } else {
            createNewUserOnFirebaseAndDirectToHomeScreen(email!, password: password!, firstName: firstName!, lastName: lastName!, birthday: nil)
        }
        
    }

    fileprivate func createNewUserOnFirebaseAndDirectToHomeScreen(_ email: String, password: String, firstName: String, lastName: String, birthday: Date?) {
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        var birthdayString: String?
        
        if let birthday = birthday {
            birthdayString = CustomDateFormatter.sharedInstance.convertDateToFirebaseStringFormat(birthday)
        }
        
        FirebaseManager.sharedManager.createUser(email, password: password, firstName: firstName, lastName: lastName, birthdayString: birthdayString, completion: {
            (success, error) -> Void in
            spinner.stopAnimating()
            if !success {
                let alertController = UIAlertController(title: "Please Try Again", message: "회원가입이 실패하였습니다. \(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(ok)
                alertController.view.tintColor = UIColor.In2DeepPurple()
                self.present(alertController, animated: true, completion: nil)
            } else {
                UIAlertController.presentAlert(self, alertTitle: "가입 성공", alertMessage: "Win2 앱에 환영합니다!", confirmTitle: "OK")
                UserDefaults.standard.set(true, forKey: kUserDidLoginBefore)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                WalkthroughManager.sharedInstance.showHomeScreen(self.view)
            }
        })
    }

    fileprivate func validatedUserInputInTextFields(_ firstName: String?, lastName: String?, password: String?, confirmationPassword: String?, email: String?, viewController: SignUpViewController) -> Bool {
        // Validate the text fields
        if let password = password, let confirmPW = confirmationPassword, let email = email {
            if password.characters.count <= 3 {
                let alert = UIAlertView(title: "Invalid Password Input", message: "Password must be greater than 3 characters", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            if !isValidEmail(email) {
                let alert = UIAlertView(title: "Invalid Email Input", message: "Please enter a valid email address", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            if confirmPW != password {
                let alert = UIAlertView(title: "Passwords Do Not Match", message: "Please make sure you've correctly entered your password in the confirmation field", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
        }
        return true
    }

    
    
    
    //MARK: UITextFieldDelegate Methods
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Email validation
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: testStr)
    }

}
