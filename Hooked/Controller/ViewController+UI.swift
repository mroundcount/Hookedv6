//
//  ViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ProgressHUD
import Firebase

extension ViewController {
    
    func setUpHeaderTitle() {
        
        let title = "Welcome to Hooked"
        let subTitle = "\n Guaranteed 15 seconds of fame"
        //creating in instance for the label. The attributes are defined as a dictionay.String.Key.Font as the key and the value is going to be an instance of UI font class.
        //We will add another key value for the text color
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 38)!, NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let attributedSubTitle = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 26), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.45)])
        //Appending the two strings
        attributedText.append(attributedSubTitle)
        //create an empty paragraph for line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        //add the paragraph to the attributed text variable
        //You can also use the \n line breakers
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        titleLbl.numberOfLines = 0
        titleLbl.attributedText = attributedText
        titleLbl.textAlignment = .center
    }
    
    //Just set up a font size, color, and centering
    func setUpOrLabel() {
        orLbl.text = "Or"
        orLbl.font = UIFont.boldSystemFont(ofSize: 16)
        orLbl.textColor = UIColor(white: 0, alpha: 0.45)
        orLbl.textAlignment = .center
    }
    //copy over from the welcome text above
    func setUpTermsLabel() {
        let attributedTermsText = NSMutableAttributedString(string: "By clicking 'Create a new account' you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let attributedTermsSubTitle = NSMutableAttributedString(string: "Terms of Service", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        //The combination of the two attributed texts
        attributedTermsText.append(attributedTermsSubTitle)
        
        termsOfServiceLbl.attributedText = attributedTermsText
        termsOfServiceLbl.numberOfLines = 0
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.termsOfServiceLbl.isUserInteractionEnabled = true
        self.termsOfServiceLbl.addGestureRecognizer(labelTap)
    }
    
    
    func setUpFacebookBtn() {
        //set the title for the button. Make sure to change the state from default to normal
        signInFacebookBtn.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        signInFacebookBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInFacebookBtn.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        //rounding off the corners
        signInFacebookBtn.layer.cornerRadius = 5
        //The functional button is clipped to the rounded corners
        signInFacebookBtn.clipsToBounds = true
        signInFacebookBtn.setImage(UIImage(named: "icon-facebook"), for: UIControl.State.normal)
        //scale and fit the image here
        signInFacebookBtn.imageView?.contentMode = .scaleAspectFit
        signInFacebookBtn.tintColor = .white
        //size and reposition the rectangle where the image is drawn
        signInFacebookBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        
        signInFacebookBtn.addTarget(self, action: #selector(fbButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    
    //Logging in with Facebook
    @objc func fbButtonDidTap() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (results, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            guard let accessToken = AccessToken.current else {
                ProgressHUD.showError("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (result, error) in
                    if let error = error {
                        print("erroring here")
                        ProgressHUD.showError(error.localizedDescription)
                        return
                    }
                if let authData = result {
                    print("authData")
                    print(authData.user.email)
                    
                    let dict: Dictionary<String, Any> = [
                        UID: authData.user.uid,
                        EMAIL: authData.user.email,
                        USERNAME: authData.user.displayName,
                        PROFILE_IMAGE_URL: authData.user.photoURL!.absoluteString,
                        STATUS: "Welcome to Hooked"
                    ]
                    
                   Ref().databaseSpecificUser(uid: authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                        (error, ref) in
                        if error == nil {
                            //This will route us back to the initial view controller. See details in appDelegate
                            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                        } else {
                            ProgressHUD.showError(error!.localizedDescription)
                        }
                    })
                }
            })
        }
    }
    
    func setUpGoogleBtn() {
        signInGoogleBtn.setTitle("Sign in with email", for: UIControl.State.normal)
        signInGoogleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInGoogleBtn.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        signInGoogleBtn.layer.cornerRadius = 5
        signInGoogleBtn.clipsToBounds = true
        signInGoogleBtn.setImage(UIImage(named: "google"), for: UIControl.State.normal)
        signInGoogleBtn.imageView?.contentMode = .scaleAspectFit
        signInGoogleBtn.tintColor = .white
        signInGoogleBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
    }
    
    func setUpCreateAccountBtn() {
        createAccountBtn.setTitle("Create a new account", for: UIControl.State.normal)
        createAccountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        createAccountBtn.backgroundColor = UIColor.black
        createAccountBtn.layer.cornerRadius = 5
        createAccountBtn.clipsToBounds = true
    }
}
