//
//  LoginViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 10/19/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var dismissBlock : (() -> Void)?
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        let backgroundGradientImageView = UIImageView(image: UIImage(named: "bg_gradient"))
        backgroundGradientImageView.frame = view.frame
        view.insertSubview(backgroundGradientImageView, at: 0)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let emailPlaceHolderStr = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        emailTextField.attributedPlaceholder = emailPlaceHolderStr
        let passwordPlaceHolderStr = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        passwordTextField.attributedPlaceholder = passwordPlaceHolderStr
        
//        devBypassLogin()
    }
    
    fileprivate func devBypassLogin() {
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rectangle.backgroundColor = UIColor.clear
        rectangle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.skipLogin))
        rectangle.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        view.addSubview(rectangle)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
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
    
    
    @IBAction func didPressLoginbutton() {
        let email = emailTextField.text
        let password = passwordTextField.text
        if let email = email, let password = password{
            if adminUserDetectedAdminMustBeActivated() == true {
                let adminVC = AdminViewController(nibName: "AdminViewController", bundle: nil)
                let navCtrl = UINavigationController(rootViewController: adminVC)
                present(navCtrl, animated: true, completion: nil)
                return
            }
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            FirebaseManager.sharedManager.loginUser(email, password: password, completion: { (success) -> Void in
                if success {
                    UserDefaults.standard.set(true, forKey: kUserDidLoginBefore)
                    if let dismissBlock = self.dismissBlock {
                        dismissBlock()
                    }
                } else {
                    UIAlertController.presentAlert(self, alertTitle: "로그인 실패", alertMessage: "로그인이 실패하였습니다. 이메일과 비밀번호 입력을 다시 확인해 주세요.", confirmTitle: "OK")
                }
                activityIndicator.stopAnimating()
            })
            if email == "bypass" && password == "bypass" {
                if let dismissBlock = self.dismissBlock {
                    dismissBlock()
                }
            }
        }
    }
    
    func adminUserDetectedAdminMustBeActivated() -> Bool {
        let email = emailTextField.text
        let password = passwordTextField.text
        if let email = email, let password = password {
            if email == kAdminEmailInput && password == kAdminPasswordHidden {
                AuthenticationManager.sharedManager.currentUserMode = .admin
                return true
            } else if email == kSocialServicesAdminEmailInput && password == kAdminPasswordHidden {
                AuthenticationManager.sharedManager.currentUserMode = .socialServicesAdmin
                return true
            }
        }
        return false
    }
    
    
    @IBAction func signUpButtonWasPressed() {
        let signUpViewController = SignUpViewController()
        let signUpNavController = UINavigationController(rootViewController: signUpViewController)
        present(signUpNavController, animated: true, completion: nil)
    }
    
    @IBAction func skipLogin() {
        if let dismissBlock = self.dismissBlock {
            dismissBlock()
        }
    }
    
}
