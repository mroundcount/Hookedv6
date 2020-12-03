//
//  PreferencesAPI.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/7/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import Firebase

class PreferencesApi {
    
    //This method does not appear to be used anywhere else.
    //11/29 Remove and test
    func uploadPreferences(user: String, value: Dictionary<String, Any>) {
        let ref = Ref().databasePreferencesUser(user: user)
        ref.childByAutoId().updateChildValues(value)
    }
    
    //This method does not appear to be used anywhere else.
    //11/29 Remove and test
    func observeNewPreferences(onSuccess: @escaping(PreferencesCompletion)) {
        Ref().databaseRoot.child("preferences").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            print(dict)
            dict.forEach({ (key, value) in
                self.getUserPreferencesforSingleEvent(user: key, onSuccess: { (preference) in
                    onSuccess(preference)
                })
            })
        }
    }
    
    
    //Maybe trying using the reference from User API.... might be worth testing.
    //Used.... take notes
    func getUserPreferencesforSingleEvent(user: String, onSuccess: @escaping(PreferencesCompletion)) {
        //print("single event step 1")
        let ref = Ref().databasePreferencesUser(user: user)
        //print("single event step 2")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            //print("single event step 3")
            if let dict = snapshot.value as? Dictionary<String, Any> {
                //print("single event step 4")
                if let preference = Preferences.transformPreferences(dict: dict) {
                    //print("single event step 5")
                    onSuccess(preference)
                }
            }
        }
    }
    
    //This method does not appear to be used anywhere else.
    //11/29 Remove and test
    func observePreferences(onSuccess: @escaping(PreferencesCompletion)) {
        //returns a snapshot of each user. We can also listed for children added, this way it can be added to the snapshot, so we don't have to reload it all the time
        Ref().databaseUsers.observe(.childAdded) { (snapshot) in
            //the value of each snapshot is like a dictionary
            if let dict = snapshot.value as? Dictionary<String, Any> {
                //encapsulate these data dictionaries in an abstract class called 'user'
                //Now we will transfor the dictionary into an object
                if let preference = Preferences.transformPreferences(dict: dict) {
                    onSuccess(preference)
                }
            }
        }
    }

    //Pulling within all of the audio files.
    func observeAudio(onSuccess: @escaping(Audio) -> Void) {
        //returns a snapshot of each user. We can also listed for children added, this way it can be added to the snapshot, so we don't have to reload it all the time
        Ref().databaseAudioFileOnly().observe(.childAdded) { (snapshot) in
            //the value of each snapshot is like a dictionary
            if let dict = snapshot.value as? Dictionary<String, Any> {
                //encapsulate these data dictionaries in an abstract class called 'user'
                //Now we will transfor the dictionary into an object
                if let audio = Audio.transformAudio(dict: dict, keyId: snapshot.key) {
                    onSuccess(audio)
                }
            }
        }
    }
    

    //Pulling audio from AudioFiles.. filters out the current artist
    //https://stackoverflow.com/questions/41606963/how-to-make-firebase-database-query-to-get-some-of-the-children-using-swift-3
    func loadAudioFile(artist: String, onSuccess: @escaping(Audio) -> Void) {
        let ref = Database.database().reference().child("audioFiles")
        ref.queryOrdered(byChild: "artist").queryEqual(toValue: artist).observe(.childAdded, with: { snapshot in
            if let dict = snapshot.value as? [String : AnyObject] {
                // do stuff with 'post' here.
                if let audio = Audio.transformAudio(dict: dict, keyId: snapshot.key) {
                    onSuccess(audio)
                }
            }
        })
    }
    
    //Looking for which audio file is liked by a given user.
    func observeNewLike(onSuccess: @escaping(AudioCompletion)) {
        Ref().databaseRoot.child("likes").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            dict.forEach({ (key, value) in
                self.getUserInforSingleEvent(id: key, onSuccess: { (audio) in
                    onSuccess(audio)
                })
            })
        }
    }
    
    //Maybe trying using the reference from User API.... might be worth testing.
    func getUserInforSingleEvent(id: String, onSuccess: @escaping(AudioCompletion)) {
        let ref = Ref().databaseSpecificAudio(id: id)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let audio = Audio.transformAudio(dict: dict, keyId: snapshot.key) {
                    onSuccess(audio)
                }
            }
        }
    }
}

typealias PreferencesCompletion = (Preferences) -> Void

//This is here for deleting records
class FirebaseManager {
    static let shared = FirebaseManager()
    private let reference = Database.database().reference()
}


