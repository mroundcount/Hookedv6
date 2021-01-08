//
//  SignUpViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleTextLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    //getting the users current location. Store these locally 
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        //Adjusting the keyboard when selecting a text field is selected
        //https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        closeBtn.setImage(UIImage(named: "close-1"), for: .normal)
    }

    func setUpUI() {
        //Methods are in SignUpViewController file
        setUpTitleTextLbl()
        setUpAvatar()
        setUpUsernameTxt()
        setUpEmailTxt()
        setUpPasswordTxt()
        setUpSignUpBtn()
        setUpSignInBtn()
        
        
    }
    //Dismissing the view and navigate back to the welcome in scene
    //Remember the action is "show"
    @IBAction func dismissionAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpBtnDidTap(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signUp(onSuccess: {
             (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view x points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    //Patching up because the validate field for the username does not work.
    func fieldIsEmptyCheck() {
        if usernameTxt.text!.isEmpty {
            signUpBtn.isEnabled = false
        } else {
            signUpBtn.isEnabled = true
        }
    }
}
