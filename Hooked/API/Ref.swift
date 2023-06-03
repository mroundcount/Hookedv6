//
//  Ref.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/6/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import Firebase

//All of our firebase related references. We'll assign one for every node. This was we do not have to hardcode elsewhere

//App reference and configuration
let URL_STORAGE_ROOT = "gs://hooked-217d3.appspot.com"

//Storage and database references
let REF_AUDIO = "audio"
let REF_AUDIO_FILE = "audioFiles"
let REF_BLOCK_USER = "blockedUser"
let REF_LIKES = "likes"
let REF_LIKE_COUNT = "likesCount"
let REF_PREFERENCES = "preferences"
let REF_REPORT_FLAG = "reportFlag"
let REF_REPORT_MESSAGE_FLAG = "reportMessageFlag"
let REF_USER = "users"
let STORAGE_PROFILE = "profile"


//User profile attributes
let PROFILE_IMAGE_URL = "profileImageUrl"
let UID = "uid"
let EMAIL = "email"
let USERNAME = "username"
let STATUS = "status"
let EXPLICIT_CONTENT = "explicitContent"
let CREATED_DATE = "createdDate"

//Error handling
let ERROR_EMPTY_EMAIL = "Please enter an email address"
let ERROR_EMPTY_USERNAME = "Please enter a username"
let ERROR_EMPTY_PASSWORD = "Please enter a password"
let ERROR_EMPTY_EMAIL_RESET = "Please enter an email address to reset your password"
//Success message for passsword resent
let SUCCESS_EMAIL_RESET = "We have just resent you a password. Please check your inbox"

//App info for landing page
let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_WELCOME = "WelcomeVC"

//Viewcontroller references
let IDENTIFIER_EDIT_PROFILE = "ProfileTableViewController"
let IDENTIFIER_UPLOAD = "UploadTableViewController"
let IDENTIFIER_EDIT_UPLOAD = "EditUploadTableViewController"
let IDENTIFIER_PREFERENCES = "PreferenceTableViewController"
let IDENTIFIER_DETAIL = "DetailViewController"
let IDENTIFIER_AUDIO_RADAR = "AudioRadarViewController"
let IDENTIFIER_LIKES = "LikesTableViewController"
let IDENTIFIER_AUDIO_REPORT = "AudioReportViewController"
let IDENTIFIER_USER_PROFILE = "UserProfileViewController"
let IDENTIFIER_USER_HOME_PAGE = "ViewController"


//Subscriptions
let REF_FOLLOWING = "following"
let REF_FOLLOWERS = "followers"

//Messaging
let IDENTIFIER_MESSAGING = "MessageVC"
let REF_MESSAGE = "messages"
let IDENTIFIER_MESSAGE_REPORT = "MessageReportViewController"





class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    //store the child node in a global variable
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    //method for taking a user id as a parameter to get the reference node
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    //Adding as a reference to sign in with a username
    func databaseSpecificUsername(username: String) -> DatabaseReference {
        return databaseUsers.child(username)
    }
    
    //StorageRoot that is stored in a global variable
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    //the child class in the firebase url
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    //getting access to the user profile reference
    func storageSpecificProfile(uid: String) -> StorageReference {
        //naigiating to the specific user usering uid
        return storageProfile.child(uid)
    }


    //adding in the new tables for just likes
    var databaseLikes: DatabaseReference {
         return databaseRoot.child(REF_LIKES)
     }
     //adding in the new tables for just likes
     func databaseLikesForUser(uid: String) -> DatabaseReference {
           return databaseLikes.child(uid)
    }
    
    //FOLLOWERS
    //WHO FOLLWS THE LOGGED IN USER. The logged in user is the child
    var databaseFollowers: DatabaseReference {
         return databaseRoot.child(REF_FOLLOWERS)
     }
    func databaseFollowersForUser(uid: String) -> DatabaseReference {
        return databaseFollowers.child(uid)
    }
    
    //FOLLOWING
    //WHO THE LOGGED IN USER IS FOLLOWING he logged in user is the parent
    var databaseFollowing: DatabaseReference {
         return databaseRoot.child(REF_FOLLOWING)
     }
     func databaseFollowingForUser(uid: String) -> DatabaseReference {
           return databaseFollowing.child(uid)
    }
    

    
    
    //adding in the new tables for just the ability to count likes
    var databaseLikesCount: DatabaseReference {
         return databaseRoot.child(REF_LIKE_COUNT)
     }
     //adding in the new tables for counting likes
     func databaseLikesCount(id: String) -> DatabaseReference {
           return databaseLikesCount.child(id)
    }
    
    
    //adding in the table for blocking users.
    var databaseBlockUser: DatabaseReference {
         return databaseRoot.child(REF_BLOCK_USER)
     }
     //adding in the new tables for blocking
     func databaseBlockUserForUser(uid: String) -> DatabaseReference {
           return databaseBlockUser.child(uid)
    }
    
    //Call all uploaded audio files
    func databaseAudioFileOnly() -> DatabaseReference {
        return databaseRoot.child(REF_AUDIO_FILE)
    }
    
    
    
    //Uploading preferences heiarchy
    var databasePreferences: DatabaseReference {
        return databaseRoot.child(REF_PREFERENCES)
    }
    
    func databasePreferencesUser(user: String) -> DatabaseReference {
        return databasePreferences.child(user)
    }


    //Uploading audio in artist heiarchy
    var databaseAudio: DatabaseReference {
        return databaseRoot.child(REF_AUDIO)
    }
    
    func databaseAudioArtist(artist: String) -> DatabaseReference {
        return databaseAudio.child(artist)
    }
 
    
    //Uploading a flag report
    func databaseReportFlag() -> DatabaseReference {
        return databaseRoot.child(REF_REPORT_FLAG)
    }
    
    //Uploading a flag report for messages
    func databaseReportMessageFlag() -> DatabaseReference {
        return databaseRoot.child(REF_REPORT_MESSAGE_FLAG)
    }
    
    //In an attempt to remove records from audioFile
    var databaseAudioFile: DatabaseReference {
        return databaseRoot.child(REF_AUDIO_FILE)
    }
    //In an attempt to remove records from audioFile
    func databaseAudioFileRef(artist: String) -> DatabaseReference {
        return databaseAudio.child(artist)
    }
  

    //Saving audio to storage
    var storageAudio: StorageReference {
        return storageRoot.child(REF_AUDIO)
    }
    
    func storageSpecificAudio(id: String) -> StorageReference {
        print("from final audio")
        return storageAudio.child(id)
    }
    
    //Used to return audio IDs from the liked database
    func databaseSpecificAudio(id: String) -> DatabaseReference {
        return databaseAudioFileOnly().child(id)
     }
    
    
    //Sending Messages
    var databaseMessage: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    
    //From origional video 34
    /*
    func databaseMessageSendTo(from: String, to: String) -> DatabaseReference {
        return databaseMessage.child(from).child(to)
    }
     */
    //Modified Method
    func databaseMessageSendTo(from: String) -> DatabaseReference {
        return databaseMessage.child(from)
    }
}
