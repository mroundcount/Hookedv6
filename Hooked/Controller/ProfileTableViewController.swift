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

import Foundation
import Firebase
import FirebaseDatabase

//The page where someone can edit the profile.
class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    @IBOutlet weak var termsOfServiceLbl: UILabel!
    @IBOutlet weak var myPreferencesLbl: UILabel!
    
    //header name give in selection atributes
    //@IBOutlet weak var genderSegment: UISegmentedControl!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        setupView()
        setUpAvatar()
        
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
    
    func setupView() {
        setUpAvatar()
        //dismiss they keyboard with a tap gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func privacyPolicyLblTap(_ sender: UITapGestureRecognizer) {
        print("Privacy label tapped")
        let alert = UIAlertController(title: "Whoa there cowboy!", message: "Yeah, I didn't write any terms yet", preferredStyle: .alert)
        
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("Whatever dude!")
        }))
    }
    
    @objc func termsOfServiceLblTap(_ sender: UITapGestureRecognizer) {
        print("Terms of Servie label tapped")
        let alert = UIAlertController(title: "Whoa there cowboy!", message: "Yeah, I didn't write any terms yet", preferredStyle: .alert)
        
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("Whatever dude!")
        }))
    }
    
    @objc func myPreferencesLblTap(_ sender: UITapGestureRecognizer) {
        print("Preference label tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let preferencesVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_PREFERENCES) as! PreferenceTableViewController
        self.navigationController?.pushViewController(preferencesVC, animated: true)
        
    }
    
    func setUpAvatar() {
        //making the UIImage circular note: height and width is 120
        avatar.layer.cornerRadius = 60
        avatar.clipsToBounds = true
        //adding actions to respond to tap gesture
        avatar.isUserInteractionEnabled = true
        //use self becauase it it is on the signUpViewController itseld
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
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
        avatar.contentMode = . scaleAspectFill
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.clearAudio()
                self.clearLikes()
                //Test this one
                self.clearLikeCount()
                self.clearPreferences()
                
                let user = Auth.auth().currentUser
                user?.delete { error in
                    if let error = error {
                        print("error")
                    } else {
                        print("Account deleted")
                    }
                }
                
                let reference = Ref().databaseSpecificUser(uid: Api.User.currentUserId)
                reference.removeValue { error, _ in
                    print(error?.localizedDescription)
                    //(UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                    Api.User.logOut()
                    print("Deleting account step 2")
                }
                print("Deleting account step 3")
                (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                
            })

        }))
        
    }
    
    func clearPhotoStorgage() {
        print("calling the delete photo")
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            //removing the URL
            print("calling the delete photo 2")
                if user.profileImageUrl != "" {
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
        
        //Just hanging on this incase I even decide to add a switch segment back.
        /*
         if genderSegment.selectedSegmentIndex == 0 {
         dict["isMale"] = true
         }
         if genderSegment.selectedSegmentIndex == 1 {
         dict["isMale"] = false
         }
         */
        
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
        
        //Dismiss view controller here. There is a delay so the changes have time to go up to firebase
        //Two seconds might be cuttin it close
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.navigationController?.popViewController(animated: true)
        })
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
        if let imageOrigional = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = imageOrigional
            avatar.image = imageOrigional
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

