//
//  ForgotPasswordViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        emailTxt.returnKeyType = UIReturnKeyType.done
        self.emailTxt.delegate = self
    }
    
    func setUpUI() {
        setUpCloseBtn()
        setUpBackground()
        setUpTitleTextLbl()
        setUpEmailTxt()
        setUpResetBtn()
    }
    
    //Dismissing the view and navigate back to the welcome in scene
    //Remember the action is "show"
    @IBAction func dismissionAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //https://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
    func textFieldShouldReturn(_ emailTxt: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func resetPasswordDidTapped(_ sender: Any) {
        //email must be validated before sending the message. FireAuth features checks for a valid email before hand
        guard let email = emailTxt.text, email != "" else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return
        }
        Api.User.resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            //dismiss the keyboard
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
}
