//
//  SignInViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleTextLbl: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    var user: User!
    var loginStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        //Adjusting the keyboard when selecting a text field is selected
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        loginStatus = "opening"
    }
    
    func setUpUI() {
        setUpBackground()
        setUpCloseBtn()
        setUpTitleTextLbl()
        setUpEmailTxt()
        setUpPasswordTxt()
        setUpSignInBtn()
        setUpSignUpBtn()
        setUpForgotPasswordBtn()
    }
    
    //Dismissing the view and navigate back to the welcome in scene
    //Remember the action is "show"
    @IBAction func dismissionAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        //Call the sign in method afte validation is complete and dismiss the keyboard
        print("Tapped")
        //This is the test script to return the username and email in this first step
        //This looks like it is just a check, I don't think we need it.
        Api.User.getUserInfoByName(username: emailTextField.text!) { (user) in
            print("In sign in 1")
            print(user.username)
            print(user.email)
        }
        
        self.view.endEditing(true)
        self.validateFields()        
        
        self.signIn(onSuccess: {
            //switch view
            self.loginStatus = "success"
            print("Login Status: \(self.loginStatus)")
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
        //After the email from username fails, a second goes by and then it checkes again with the email address.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            print("Login Status: \(self.loginStatus)")
            if self.loginStatus != "success" {
                print("FAILURE")
                //Once it fails we're going to apply the old system
                self.signInWithEmail(onSuccess: {
                    //switch view
                    self.loginStatus = "failure"
                    print("Login Status: \(self.loginStatus)")
                    (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            }
        })
    }
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -75 // Move view x points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
}
