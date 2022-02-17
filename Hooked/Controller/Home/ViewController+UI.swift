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
import FirebaseAuth
import CryptoKit
import AuthenticationServices


extension ViewController {
    
    func setBackgroundImg() {
        let randomInt = Int.random(in: 1..<4)
        print("Background Img: \(randomInt)")
        if randomInt == 1 {
            backgroundImg.image=UIImage(named: "background_landing1")
        } else if randomInt == 2 {
            backgroundImg.image=UIImage(named: "background_landing2")
        } else if randomInt == 3 {
            backgroundImg.image=UIImage(named: "background_landing3")
        }
        
        
    //Adjusting the image
        let coverLayer = CALayer()
        coverLayer.frame = backgroundImg.bounds;
        coverLayer.backgroundColor = UIColor.black.cgColor
        coverLayer.opacity = 0.55
        backgroundImg.layer.addSublayer(coverLayer)
    }
    
    func setUpHeaderTitle() {
        let color = getUIColor(hex: "#66CD5D")
        let title = "Welcome to \n Hooked"
        let subTitle = "\n Guaranteed 15 seconds of fame"
        //creating in instance for the label. The attributes are defined as a dictionay.String.Key.Font as the key and the value is going to be an instance of UI font class.
        //We will add another key value for the text color
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Arial Hebrew", size: 25)!, NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let attributedSubTitle = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor : color])
        
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
    
    func setUpSignInEmailBtn() {
        let color = getUIColor(hex: "#66CD5D")
        signInEmailBtn.setTitle("Sign in with email", for: UIControl.State.normal)
        signInEmailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signInEmailBtn.setTitleColor(color, for: .normal)
        signInEmailBtn.backgroundColor = UIColor.clear
        signInEmailBtn.layer.borderWidth = 2
        signInEmailBtn.layer.borderColor = UIColor.green.cgColor
        signInEmailBtn.layer.cornerRadius = 27.5
        signInEmailBtn.clipsToBounds = true
    }
    /*
    // Green filled button for a demo.
    func setUpSignInEmailBtn() {
        let color = getUIColor(hex: "#66CD5D")
        signInEmailBtn.setTitle("Sign in with email", for: UIControl.State.normal)
        signInEmailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signInEmailBtn.titleLabel?.textColor = UIColor.white
        signInEmailBtn.backgroundColor = color
        signInEmailBtn.layer.cornerRadius = 27.5
        signInEmailBtn.clipsToBounds = true
    }
    */
    func setUpCreateAccountBtn() {
        let color = getUIColor(hex: "#66CD5D")
        createAccountBtn.setTitle("Create a new account", for: UIControl.State.normal)
        createAccountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        createAccountBtn.titleLabel?.textColor = UIColor.white
        createAccountBtn.backgroundColor = color
        createAccountBtn.layer.cornerRadius = 27.5
        createAccountBtn.clipsToBounds = true
    }
    

    
    //Just set up a font size, color, and centering
    func setUpOrLabel() {
        orLbl.text = "OR"
        orLbl.font = UIFont.boldSystemFont(ofSize: 16)
        orLbl.textColor = UIColor.white
        orLbl.textAlignment = .center
    }
    
    //copy over from the welcome text above
    func setUpTermsLabel() {
        let color = getUIColor(hex: "#66CD5D")
        let attributedTermsText = NSMutableAttributedString(string: "By clicking 'Create a new account' you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let attributedTermsSubTitle = NSMutableAttributedString(string: "Terms of Service", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : color])
        
        //The combination of the two attributed texts
        attributedTermsText.append(attributedTermsSubTitle)
        
        termsOfServiceLbl.attributedText = attributedTermsText
        termsOfServiceLbl.numberOfLines = 0
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.termsOfServiceLbl.isUserInteractionEnabled = true
        self.termsOfServiceLbl.addGestureRecognizer(labelTap)
        self.termsOfServiceLbl.textAlignment = .center
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
    
    /*
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
    */
    /*
    //Logging in with Facebook
    @objc func fbButtonDidTap() {
        
        print("Getting token 1")
        //pre-login
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (results, error) in
            if let error = error {
                print("Getting token 2")
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Getting token 3")
                ProgressHUD.showError("Failed to get access token")
                return
            }
                
            //hit
            print("Getting token 4")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (result, error) in
                    if let error = error {
                        print("Getting token 5")
                        print("erroring here")
                        ProgressHUD.showError(error.localizedDescription)
                        return
                    }
                if let authData = result {
                    //hit
                    print("Getting token 6")
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
                            //hit
                            print("Getting token 7")
                            //This will route us back to the initial view controller. See details in appDelegate
                            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                        } else {
                            ProgressHUD.showError(error!.localizedDescription)
                            print("Getting token 8")
                        }
                    })
                }
            })
        }
    }
    */
    /*
    func setUpAppleBtn() {
        //set the title for the button. Make sure to change the state from default to normal
        signInAppleBtn.setTitle("Sign in with Apple", for: UIControl.State.normal)
        signInAppleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        //signInAppleBtn.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        //rounding off the corners
        signInAppleBtn.layer.cornerRadius = 5
        //The functional button is clipped to the rounded corners
        signInAppleBtn.clipsToBounds = true
        //signInAppleBtn.setImage(UIImage(named: "icon-facebook"), for: UIControl.State.normal)
        //scale and fit the image here
        //signInAppleBtn.imageView?.contentMode = .scaleAspectFit
        //signInAppleBtn.tintColor = .white
        //size and reposition the rectangle where the image is drawn
        //signInAppleBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        signInAppleBtn.addTarget(self, action: #selector(appleButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    */
    /*
    @objc func appleButtonDidTap() {
        print("apple button tapped")
    }
    */
    /*
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
    */

}




