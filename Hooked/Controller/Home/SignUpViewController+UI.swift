//
//  SignUpViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD
import CoreLocation

extension SignUpViewController {
    
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
        let title = "Sign Up"
        //copy over from ViewController+UI
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Arial Hebrew", size: 35)!, NSAttributedString.Key.foregroundColor : color])
        titleTextLbl.attributedText = attributedText
        titleTextLbl.textAlignment = .center
    }
    
    func setUpIcon() {
        print("place holder")
    }

    
    func setUpUsernameTxt() {
        let color = getUIColor(hex: "#66CD5D")
        usernameContainerView.layer.borderWidth = 2
        //note the type for border color is cgColor
        usernameContainerView.layer.borderColor = UIColor.green.cgColor
        usernameContainerView.layer.cornerRadius = 27.5
        usernameContainerView.clipsToBounds = true
        usernameContainerView.backgroundColor = UIColor.clear
        //we don't need the border for the full name text field. Tthis is because the container came with a border
        usernameTxt.borderStyle = .none
        //coding in the placeholder string with the same key value pairing attributed string just like on ViewController+UI.
        let placeholderAttr = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        usernameTxt.attributedPlaceholder = placeholderAttr
        usernameTxt.textColor = color
    }
    func setUpEmailTxt() {
        let color = getUIColor(hex: "#66CD5D")
        emailContainerView.layer.borderWidth = 2
        emailContainerView.layer.borderColor = UIColor.green.cgColor
        emailContainerView.layer.cornerRadius = 27.5
        emailContainerView.clipsToBounds = true
        emailContainerView.backgroundColor = UIColor.clear
        emailTxt.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        emailTxt.attributedPlaceholder = placeholderAttr
        emailTxt.textColor = color
    }
    
    func setUpPasswordTxt() {
        let color = getUIColor(hex: "#66CD5D")
        //the encryption text should be done in storyboard
        passwordContainerView.layer.borderWidth = 2
        passwordContainerView.layer.borderColor = UIColor.green.cgColor
        passwordContainerView.layer.cornerRadius = 27.5
        passwordContainerView.clipsToBounds = true
        passwordContainerView.backgroundColor = UIColor.clear
        passwordTxt.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Password (6+ Characters)", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        passwordTxt.attributedPlaceholder = placeholderAttr
        passwordTxt.textColor = color
    }
    
    func setUpSignUpBtn() {
        let color = getUIColor(hex: "#66CD5D")
        signUpBtn.setTitle("Sign Up", for: UIControl.State.normal)
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        signUpBtn.backgroundColor = UIColor.white
        signUpBtn.layer.cornerRadius = 27.5
        signUpBtn.clipsToBounds = true
        signUpBtn.setTitleColor(.white, for: UIControl.State.normal)
        signUpBtn.backgroundColor = color
        
    }
    
    func setUpSignInBtn() {
        let color = getUIColor(hex: "#66CD5D")
        // We're going to apply the key value UI attributed string to a UI button
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let attributedSubText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : color])
        
        attributedText.append(attributedSubText)
        signInBtn.setAttributedTitle(attributedText, for: UIControl.State.normal)
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
    
    
    //Dismissing the keyboard. Looks for the repsonder to the text field to give up the startis
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func validateFields() {
        //making sure the fields are in good form. ProgressHUD has a lot of built in features for this.
        print("We're in the field validation")
        guard let username = self.usernameTxt.text, !username.isEmpty else {
            //Might want to consider using ProgressHUD.showError
            ProgressHUD.showError(ERROR_EMPTY_USERNAME)
            print("We're in the username")
            return
        }
        
        guard let email = self.emailTxt.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            print("We're in the email")
            return
        }
        guard let password = self.passwordTxt.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            print("We're in the password")
            return
        }
        
        print("Getting out of validation")
        //missing image... all or nothing we should add an alert here if taking it out.
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        if usernameTxt.text!.isEmpty {
            print("no username")
        } else {

            print("we are now in sign up")
            ProgressHUD.show("Loading...")
            //passing all of the paramters into the user API. Assign all text fields to the appropriate parameters.
            //this is where I might remove image: self.image,
            Api.User.signUp(withUsername: self.usernameTxt.text!, email: self.emailTxt.text!, password: self.passwordTxt.text!, image: self.image, onSuccess: {
                print("In the first step of the API")
                ProgressHUD.dismiss()
                print("Right before on success")
                onSuccess()
                self.resetPreferences()
            }) { (errorMessage) in
                onError(errorMessage)
            }
        }
    }
    
    func resetPreferences() {
        let pref = true
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Alternative Rock" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Ambient" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Classical" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Country" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dance & EDM" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dancehall" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Deep House" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Disco" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Drum & Bass" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dubstep" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Electronic" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Folk" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Hip-hop & Rap" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["House" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Indie" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Jazz & Blues" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Latin" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Metal" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Piano" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Pop" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["R&B & Soul" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Reggae" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Reggaeton" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Rock" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Techno" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Trance" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Trap" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Triphop" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["World" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
    }
    
    
}
/*
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //updating the avatar any time a user picks up an image.
    //display the photo on the UIIMage view. Use editedImage so if the photo is edited this info will return on the edited photo.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = imageSelected
            icon.image = imageSelected
            
        }
        //If the user does not update their avatar. It will return to the default image
        if let imageOrigional = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = imageOrigional
            icon.image = imageOrigional
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
*/
