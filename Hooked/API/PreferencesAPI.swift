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
    
    //Maybe trying using the reference from User API.... might be worth testing.
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
}

typealias PreferencesCompletion = (Preferences) -> Void

//This is here for deleting records
class FirebaseManager {
    static let shared = FirebaseManager()
    private let reference = Database.database().reference()
}


