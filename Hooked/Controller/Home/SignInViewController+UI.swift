//
//  SignInViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD

extension SignInViewController {
    
    func setUpCloseBtn() {
        closeBtn.setImage(UIImage(named: "close-1"), for: .normal)
        closeBtn.backgroundColor = UIColor.gray
        closeBtn.layer.cornerRadius = 15
    }
    
    func setUpBackground() {
        self.view.backgroundColor = UIColor.black
    }
    
    func setUpTitleTextLbl() {
        let color = getUIColor(hex: "#66CD5D")
        let title = "Sign In"
        //copy over from ViewController+UI
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Arial Hebrew", size: 35)!, NSAttributedString.Key.foregroundColor : color])
        titleTextLbl.attributedText = attributedText
        titleTextLbl.textAlignment = .center
    }
    
    
    func setUpEmailTxt() {
        let color = getUIColor(hex: "#66CD5D")
        emailContainerView.layer.borderWidth = 2
        emailContainerView.layer.borderColor = UIColor.green.cgColor
        emailContainerView.layer.cornerRadius = 27.5
        emailContainerView.clipsToBounds = true
        emailContainerView.backgroundColor = UIColor.clear
        emailTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Username or Email", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        emailTextField.attributedPlaceholder = placeholderAttr
        emailTextField.textColor = color
    }
    
    func setUpPasswordTxt() {
        let color = getUIColor(hex: "#66CD5D")
        passwordContainerView.layer.borderWidth = 2
        passwordContainerView.layer.borderColor = UIColor.green.cgColor
        passwordContainerView.layer.cornerRadius = 27.5
        passwordContainerView.clipsToBounds = true
        passwordContainerView.backgroundColor = UIColor.clear
        passwordTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = color
    }
    
    func setUpSignInBtn() {
        let color = getUIColor(hex: "#66CD5D")
        signInBtn.setTitle("Sign In", for: UIControl.State.normal)
        signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        signInBtn.backgroundColor = UIColor.white
        signInBtn.layer.cornerRadius = 27.5
        signInBtn.clipsToBounds = true
        signInBtn.setTitleColor(.white, for: UIControl.State.normal)
        signInBtn.backgroundColor = color
    }
    
    func setUpForgotPasswordBtn() {
        let color = getUIColor(hex: "#66CD5D")
        forgotPasswordBtn.setTitle("Forgot Password", for: UIControl.State.normal)
        forgotPasswordBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        forgotPasswordBtn.setTitleColor(color, for: .normal)
        forgotPasswordBtn.backgroundColor = UIColor.clear
        forgotPasswordBtn.layer.borderWidth = 2
        forgotPasswordBtn.layer.cornerRadius = 15
        forgotPasswordBtn.clipsToBounds = true
        forgotPasswordBtn.layer.borderColor = UIColor.green.cgColor
    }
    
    func setUpSignUpBtn() {
        let color = getUIColor(hex: "#66CD5D")
        //copy attributed string key values from SignUpViewController+UI
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let attributedSubText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : color])
        
        attributedText.append(attributedSubText)
        signUpBtn.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    //Function for converting HEX to RGBA
    //https://www.zerotoappstore.com/how-to-set-custom-colors-swift.html
    func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }
        if ((cleanString.count) != 6) {
            return nil
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //Looks like this is just making sure that all of the fields are filled out
    func validateFields() {
        //copied from signUpViewController+UI
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    //Dismissing the keyboard. Looks for the repsonder to the text field to give up the startis
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Close tapped")
        self.view.endEditing(true)
    }
    
    //copied from SignUp
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show("Loading...")
        //looking up the value of the user profile based on what is in the email field
        Api.User.getUserInfoByName(username: emailTextField.text!) { (user) in
            //passing in the user email from the profile
            Api.User.signIn(email: user.email, password: self.passwordTextField.text!, onSuccess: {
                ProgressHUD.dismiss()
                onSuccess()
            }) { (errorMessage) in
                onError(errorMessage)
            }
        }
    }

    //After a failure, two seconds later it will perform a check with the email address
    func signInWithEmail(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show("Loading...")
        Api.User.signIn(email: self.emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}
