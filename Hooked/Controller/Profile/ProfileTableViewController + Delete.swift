//
//  ProfileTableViewController + Delete.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/4/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import Foundation
import Firebase
import FirebaseDatabase


extension ProfileTableViewController {
 
    
    func deleteProfile() {
        print("deleting account")
        let alert = UIAlertController(title: "Whoa there cowboy!", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
 
            self.clearPhotoStorgage()
            let reference = Ref().databaseSpecificUser(uid: Api.User.currentUserId)
            print("Deleting photo storage")
            //Calling the userID up here
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                
                print("Deleting my firebase info")
                self.clearAudio()
                self.clearLikes()
                self.clearLikeCount()
                self.clearMyAudioFromOthersLikes()
                self.clearPreferences()
                
                //Needs to be cleared in this order
                self.clearMySubscriptions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Deleting my subscriptions")
                    self.clearMeFromFollowers()
                    self.clearMyFollowers()
                }
                self.clearMySentMessages()
                
                // Deleting the authentication from Firebase
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("Deleting my authentication")
                    //This is the method that actually deletes a user from the authentication side of Firebase
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                        if let error = error {
                            print("error in deleting account from authenitcation")
                            print(error)
                        } else {
                            print("Account deleted from authenitcation!!")
                        }
                    }
                    
                    //This might be our problem point if we navigate out too quickly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print("Navigating back to home page")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let preferencesVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_USER_HOME_PAGE) as! ViewController
                        self.navigationController?.pushViewController(preferencesVC, animated: true)
                        //(UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                    }
                    
                    //Removing the user name at this point and referencing it above so we can pass the ID into the previous function
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //let reference = Ref().databaseSpecificUser(uid: Api.User.currentUserId)
                        print("Deleting my username from realtime database")
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
    
    func clearMyAudioFromOthersLikes() {
        Api.Audio.loadAudioFile(artist: Api.User.currentUserId) { (audio) in
            //NOTE let's try and combine these next time as
            //queryStarting(atValue: true).queryEnding(atValue: 1)
            
            //Getting all of my audioIDs
            let selection = audio.id
            print("My audio ID \(selection)")
            //Retreiving all of the records where the audioID is in a like.
            let ref = Database.database().reference().child("likes")
            //removing all of the value where the query = true
            ref.queryOrdered(byChild: selection).queryStarting(atValue: 1).observe(.value, with: { (snapshot: DataSnapshot!) in
                //Getting the parent value containing all of our audioIDs
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let usersWithLikes = child.key
                    //Running through all of the parentIDs and selecting the record containing the audio files.
                    let reference = Ref().databaseLikesForUser(uid: usersWithLikes).child(selection)
                    print("Reference for deletion: \(reference)")
                    
                    //Rovming the records
                    reference.removeValue { error, _ in
                        print(error?.localizedDescription)
                    }
                }
            })
            ref.queryOrdered(byChild: selection).queryEqual(toValue: true).observe(.value, with: { (snapshot: DataSnapshot!) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let usersWithLikes = child.key
                    let reference = Ref().databaseLikesForUser(uid: usersWithLikes).child(selection)
                    print("Reference for deletion: \(reference)")

                    reference.removeValue { error, _ in
                        print(error?.localizedDescription)
                    }
                }
            })
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
    
    //Deleting the logged in user from other profiles
    func clearMySubscriptions() {
        //Surgically removing the logged in user from other's
        Api.User.observeUsersIamFollowing { (following) in
            let usersIamFollowing = following.uid
            print("I am following \(usersIamFollowing)")
            //Retreiving all of the records of those people I AM FOLLOWING
            let ref = Database.database().reference().child("followers")
            //removing all of the value where the query has a value
            ref.queryOrdered(byChild: Api.User.currentUserId).queryStarting(atValue: 1).observe(.value, with: { (snapshot: DataSnapshot!) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let usersIamFollowing = child.key
                    //The child is a logged in user.... we have to remove it from all of the still active users
                    let reference = Ref().databaseFollowersForUser(uid: usersIamFollowing).child(Api.User.currentUserId)
                    print("Reference for deletion: \(reference)")
                    
                    //Rovming the records
                    reference.removeValue { error, _ in
                        print(error?.localizedDescription)
                    }
                }
            })
        }
    }
    
    func clearMeFromFollowers() {
        //Removing the parent record that is created for logged in user when other subscribe to them.
        let reference = Ref().databaseFollowersForUser(uid: Api.User.currentUserId)
        reference.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }
    
    //Deleting the logged in user's list of following
    func clearMyFollowers() {
        let reference = Ref().databaseFollowingForUser(uid: Api.User.currentUserId)
        reference.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }
    
    //Deleting messages I have sent.
    func clearMySentMessages() {
        let reference = Ref().databaseMessageSendTo(from: Api.User.currentUserId)
        reference.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }
    
}
