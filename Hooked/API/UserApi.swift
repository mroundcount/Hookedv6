//
//  UserApi.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/6/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import ProgressHUD

//All methods of the user business services (create user, sign in, etc.)
class UserApi {
    
    //returns the user ID of the user logged in
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    //signs in based on an email address and password. I added the username login in addition to this.
    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        //This is specifically for email and password. There are other built in tools in Auth
        Auth.auth().signIn(withEmail: email, password: password) {
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            //print(authData?.user.uid)
            onSuccess()
        }
    }

    
    //function with the input parameters we need to pass in. We need all this info from the signUpView controller and now we need to pass all the parameters into this method
    //I removed all references to uploading the image.
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        print("In the first step of the UserApi API")
        //firebase authentication. Create user methed creates an account. Result and error are object receieved from firebase after the creation process.
        Auth.auth().createUser(withEmail: email, password: password) {
            (AuthDataResult, error) in
            print("In the second step of the API")
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            //Results returns all users info
            if let authData = AuthDataResult {
                print("In the third step of the API")
                //dictionary to hold all the user data
                let dict: Dictionary<String, Any> = [
                    UID: authData.user.uid,
                    EMAIL: authData.user.email,
                    USERNAME: username,
                    PROFILE_IMAGE_URL: "",
                    STATUS: 1,
                    EXPLICIT_CONTENT: false,
                    CREATED_DATE: Date().timeIntervalSince1970
                    
                ]
                 print("In the fourth step of the API")

                
                let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
                //upload the image data to Firebase.
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                //Use the StorageService API and pass in the parameters
                
                StorageService.savePhoto(username: username, uid: authData.user.uid, /*data: imageData,*/ metadata: metadata, storageProfileRef: storageProfile, dict: dict, onSuccess: {
                    onSuccess()
                }, onError: { (errorMessage) in
                    onError(errorMessage)
                })
            }
        }
        //resetPreferences()
    }
    
    
    //Saving the pushing up the dictionary from the profile view controller. This is called when the user updates their profile.
    func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        //make sure the data is being updated for the current user.
        Ref().databaseSpecificUser(uid: Api.User.currentUserId).updateChildValues(dict) { (error, dataRef) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        //use the built in auth reset password function.
        //This can be customized in Firebase in Auth
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
    
    func logOut() {
        //user the built in FirebaseAuth functions
        do {
            try Auth.auth().signOut()
            //Messaging.messaging().unsubscribe(fromTopic: uid)
        } catch {
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        //This will route us back to the initial view controller. See details in appDelegate
        (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
    }
    

    //Used all over the place.
    func observeUsers(onSuccess: @escaping(UserCompletion)) {
        //returns a snapshot of each user. We can also listed for children added, this way it can be added to the snapshot, so we don't have to reload it all the time
        Ref().databaseUsers.observe(.childAdded) { (snapshot) in
            //the value of each snapshot is like a dictionary
            if let dict = snapshot.value as? Dictionary<String, Any> {
                //encapsulate these data dictionaries in an abstract class called 'user'
                //Now we will transfor the dictionary into an object
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    //Looking for users blocked by the current user.
    func observeBlockedUsers(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseRoot.child("blockedUser").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            dict.forEach({ (key, value) in
                self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                    onSuccess(user)
                })
            })
        }
    }
    
    //Looking for artists the current user is following.
    func observeUsersIamFollowing(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseRoot.child("following").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.forEach({ (key, value) in
                self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                    onSuccess(user)
                })
            })
        }
    }
    
    //Looking other users that follow the logged in user
    func observeMyFollowers(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseRoot.child("followers").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            dict.forEach({ (key, value) in
                self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                    onSuccess(user)
                })
            })
        }
    }
    
    //For data that only needs to be changed one or infrequently (ie profile photos)
    //prevents cetrain loadings from happening multiple times like when we changed the profile photo in video 50
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    //Allows up to return the user info of which ever user we pass into the uid aregument.
    //Not sure where this is actually being used.... might want to consider removing it later
    func getUserInfo(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    //This is used for signing in with a usernmane
    func getUserInfoByName(username: String, onSuccess: @escaping(User) -> Void) {
        let ref = Database.database().reference().child("users")
        
        ref.queryOrdered(byChild: "username").queryEqual(toValue: username).observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String : AnyObject] {
                // do stuff with 'post' here.
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        })
        
        ref.queryOrdered(byChild: "email").queryEqual(toValue: username).observe(.childAdded, with: {
             snapshot in
             if let dict = snapshot.value as? [String : AnyObject] {
                 // do stuff with 'post' here.
                 if let user = User.transformUser(dict: dict) {
                     onSuccess(user)
                 }
             }
         })
    }
}

//in the api call the observeUsers functions can accept multiple closure arements. Be declaring typealias the alias name can be used anywhere in the app instead of the type. THe name reffers to an already existing type
typealias UserCompletion = (User) -> Void




