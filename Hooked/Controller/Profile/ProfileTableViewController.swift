//
//  ProfileTableViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/21/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseAuth


import FirebaseStorage

import Foundation
import Firebase
import FirebaseDatabase

//The page where someone can edit the profile.
class ProfileTableViewController: UITableViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    @IBOutlet weak var termsOfServiceLbl: UILabel!
    @IBOutlet weak var myPreferencesLbl: UILabel!
    
    @IBOutlet weak var explicitContentSegment: UISegmentedControl!
    
    var image: UIImage?
    var credential: AuthCredential?

    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        setUpUI()
        setupView()
        
        //Make it so we cannot edit field.
        self.emailTextField.isUserInteractionEnabled = false
        self.usernameTextField.isUserInteractionEnabled = false
        
        let privacyPolicyLblTap = UITapGestureRecognizer(target: self, action: #selector(self.privacyPolicyLblTap(_:)))
        self.privacyPolicyLbl.isUserInteractionEnabled = true
        self.privacyPolicyLbl.addGestureRecognizer(privacyPolicyLblTap)
        
        let termsOfServiceLblTap = UITapGestureRecognizer(target: self, action: #selector(self.termsOfServiceLblTap(_:)))
        self.termsOfServiceLbl.isUserInteractionEnabled = true
        self.termsOfServiceLbl.addGestureRecognizer(termsOfServiceLblTap)
        
        let myPreferencesLblTap = UITapGestureRecognizer(target: self, action: #selector(self.myPreferencesLblTap(_:)))
        self.myPreferencesLbl.isUserInteractionEnabled = true
        self.myPreferencesLbl.addGestureRecognizer(myPreferencesLblTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupView() {
        //dismiss they keyboard with a tap gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func privacyPolicyLblTap(_ sender: UITapGestureRecognizer) {
        print("Privacy label tapped")
        if let url = NSURL(string: "https://hookedmusic.app/Terms.pdf") {
            UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
        }
    }
    
    @objc func termsOfServiceLblTap(_ sender: UITapGestureRecognizer) {
        print("Terms of Servie label tapped")
        
        if let url = NSURL(string: "https://hookedmusic.app/Terms.pdf") {
            UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
        }
    }
    
    @objc func myPreferencesLblTap(_ sender: UITapGestureRecognizer) {
        print("Preference label tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let preferencesVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_PREFERENCES) as! PreferenceTableViewController
        self.navigationController?.pushViewController(preferencesVC, animated: true)
        
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        ProgressHUD.show("Loading...")
        
        //saving the updated text fields. We're going to be doing it the whole dictonary at a time
        var dict = Dictionary<String, Any>()
        
        if let username = usernameTextField.text, !username.isEmpty {
            dict["username"] = username
        }
        if let email = emailTextField.text, !email.isEmpty {
            dict["email"] = email
        }
        
        if let website = websiteTextField.text, !website.isEmpty {
            dict["website"] = website
        }
        
        //explicitContent
        if explicitContentSegment.selectedSegmentIndex == 0 {
            dict["explicitContent"] = true
        }
        if explicitContentSegment.selectedSegmentIndex == 1 {
            dict["explicitContent"] = false
        }

        //Calling a method in user to save the dictonary above to the database
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            //making sure the image variable is not nil. We need to get and process in it to upload to the database
            if let img = self.image {
                //call the methos in the storageServices to actually save the updated photo to the datebase
                StorageService.savePhotoProfile(image: img, uid: Api.User.currentUserId, onSuccess: {
                    ProgressHUD.showSuccess()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            } else {
                ProgressHUD.showSuccess()
            }
            
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
        //updating email in the authentication storage
        //https://stackoverflow.com/questions/54958026/how-to-update-email-address-in-firebase-authentication-in-swift-4
        let user = Auth.auth().currentUser
        var credential: AuthCredential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
        // Prompt the user to re-provide their sign-in credentials
        //We need to reauthenticate in order to delete the facebook account
        //https://stackoverflow.com/questions/52159866/updated-approach-to-reauthenticate-a-user
        user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
                    if let error = error {
                        // An error happened.
                    }else{
                        let user = Auth.auth().currentUser
                        user?.updateEmail(to: self.emailTextField.text ?? "email") { (error) in
                            // email updated
                        }
                    }
                })

        
        //Dismiss view controller here. There is a delay so the changes have time to go up to firebase
        //Two seconds might be cuttin it close
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    //allowing users to select images from the library
    @objc func presentPicker() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        //users can edit the selected photo
        picker.allowsEditing = true
        //enable methods in the UIImage picker delegate
        picker.delegate = self
        //Making the image fill the entire UIIMage space
        avatar.contentMode = .scaleToFill
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func observeData() {
        //fetching current user data
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.websiteTextField.text = user.website
            self.avatar.loadImage(user.profileImageUrl)
            //adding age and genedner to the user model. These are editable and push to the database
            if user.explicitContent == true {
                self.explicitContentSegment.selectedSegmentIndex = 0
            } else {
                self.explicitContentSegment.selectedSegmentIndex = 1
            }
            
        }
    }
    
    @IBAction func logoutBtnDidTap(_ sender: Any) {
        Api.User.logOut()
        print("Loggin out")
    }
    
    @IBAction func deleteBtnDidTap(_ sender: Any) {
                
        print("deleting account")
        let alert = UIAlertController(title: "Whoa there cowboy!", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
 
            self.clearPhotoStorgage()
            
            let reference = Ref().databaseSpecificUser(uid: Api.User.currentUserId)

            //Calling the userID up here
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

                self.clearAudio()
                self.clearLikes()
                //Test this one
                self.clearLikeCount()
                self.clearPreferences()
                

                //I think this was just for facebook
                /*
                let user = Auth.auth().currentUser
                var credential: AuthCredential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
                // Prompt the user to re-provide their sign-in credentials
                //We need to reauthenticate in order to delete the facebook account
                //https://stackoverflow.com/questions/52159866/updated-approach-to-reauthenticate-a-user
                user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
                            if let error = error {
                                // An error happened.
                            }else{
                                // User re-authenticated.
                            }
                        })
                 */


                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //This is the method that actually deletes a user from the authentication side of Firebase
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                        if let error = error {
                            print("error")
                        } else {
                            print("Account deleted")
                        }
                    }
                    print("Deleting account step 3")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let preferencesVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_USER_HOME_PAGE) as! ViewController
                    self.navigationController?.pushViewController(preferencesVC, animated: true)
                    //(UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                    
                    
                    //Removing the user name at this point and referencing it above so we can pass the ID into the previous function
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //let reference = Ref().databaseSpecificUser(uid: Api.User.currentUserId)
                        reference.removeValue { error, _ in
                            print(error?.localizedDescription)
                            print("Deleting account step 2")
                        }
                    }
                    
                    
                    
                }
            })
        }))
    }
    
    func clearPhotoStorgage() {
        print("calling the delete photo")
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            //removing the URL
            print("calling the delete photo 2")
            if user.profileImageUrl != "" {
                if user.profileImageUrl.contains("facebook") {
                   print("facebook URL, not in storage. Do nothing")
                } else {
            
                    let photoStorageURL = user.profileImageUrl
                    let photoStorageURLDelete = photoStorageURL.subString(from:81,to:108)
                    print("photoStorageURLDelete: \(photoStorageURL.subString(from:81,to:108))")
                    let desertRef = Ref().storageSpecificProfile(uid: photoStorageURLDelete)
                    // Delete the file
                    desertRef.delete { error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                        } else {
                            // File deleted successfully
                        }
                    }
                }
            }
        }
    }

    func clearPreferences() {
        let reference = Ref().databasePreferencesUser(user: Api.User.currentUserId)
        reference.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }
    
    func clearLikes() {
        let reference = Ref().databaseLikesForUser(uid: Api.User.currentUserId)
        reference.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }


    func clearAudio() {
        Api.Audio.loadAudioFile(artist: Api.User.currentUserId) { (audio) in
            
            //removing the URL
            let storageURL = audio.audioUrl
            let storageURLDelete = storageURL.subString(from:79,to:114)
            print("StorageURL: \(storageURL.subString(from:79,to:114))")
            let desertRef = Ref().storageSpecificAudio(id: storageURLDelete)
            // Delete the file
            desertRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // File deleted successfully
                }
            }
            
            Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
                //removing the URL
                print("calling the delete photo")
                let photoStorageURL = user.profileImageUrl
                let photoStorageURLDelete = photoStorageURL.subString(from:81,to:108)
                print("photoStorageURLDelete: \(photoStorageURLDelete)")
                let desertRef = Ref().storageSpecificProfile(uid: photoStorageURLDelete)
                // Delete the file
                desertRef.delete { error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                    }
                }
            }
            
            
            //creates an array called "audioCollection" which containts all the audio files
            let selection = audio.id
            let reference = Database.database().reference().child("audioFiles").child(selection)
            print("Reference from deletion: \(reference)")
            //Test making the error optional
            reference.removeValue { error, _ in
                print(error?.localizedDescription)
            }
        }
    }
    
    func clearLikeCount() {
        Api.Audio.loadAudioFile(artist: Api.User.currentUserId) { (audio) in
            //creates an array called "audioCollection" which containts all the audio files
            let selection = audio.id
            let reference = Database.database().reference().child("likesCount").child(selection)
            print("Reference from deletion: \(reference)")
            //Test making the error optional
            reference.removeValue { error, _ in
                print(error?.localizedDescription)
            }
        }
    }
}


//Method for the immage piker delegate.
extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //updating the avatar any time a user picks up an image.
    //display the photo on the UIIMage view. Use editedImage so if the photo is edited this info will return on the edited photo.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = imageSelected
            avatar.image = imageSelected
        }
        //If the user does not update their avatar. It will return to the default image
        // 1/26/2022 I removed this code based on this video saying we only needed one or the other. We should test this. https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
        /*
        if let imageOrigional = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = imageOrigional
            avatar.image = imageOrigional
        }
         */
        picker.dismiss(animated: true, completion: nil)
    }
}

