//
//  User.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/7/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
//each instance of this call holds an instance of a user from the database
class User {
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var profileImage = UIImage()
    var status: Any
    //var age: Int?
    var latitude = ""
    var longitude = ""
    var website: String?
    var explicitContent: Bool?
    
    
    
    //teaching the class to create a new instance
    //We create an initializer. Assign each parameter to an instance variable
    init(uid: String, username: String, email: String, profileImageUrl: String, status: Any) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.status = status
    }
    
    //The method that excepts the dictionary and turns it into the users varaible
    static func transformUser(dict: [String: Any]) -> User? {
        //use gaurd to unwrap the data from the dictionary
        guard let email = dict["email"] as? String,
        let username = dict["username"] as? String,
        let profileImageUrl = dict["profileImageUrl"] as? String,
        let status = dict["status"] as? Any,
        let uid = dict["uid"] as? String else {
            return nil
        }
        //assign all of the unwrapped data to the instnce user, and return the full user at the end
        let user = User (uid: uid, username: username, email: email, profileImageUrl: profileImageUrl, status: status)
        
        //Attempting to fix observer in video 72
        if let latitude = dict["current_latitude"] as? String {
            user.latitude = latitude
        }
        if let longitude = dict["current_longitude"] as? String {
            user.longitude = longitude
        }
        
        if let website = dict["website"] as? String {
            user.website = website
        }
        //let explicitContent = dict["explicitContent"] as? Bool == nil ? false : (dict["explicitContent"]! as! Bool)
        
        if let explicitContent = dict["explicitContent"] as? Bool {
            user.explicitContent = explicitContent
        }
        
        return user
    }

}


extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
