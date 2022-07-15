//
//  Likes.swift
//  Hooked
//
//  Created by Michael Roundcount on 4/19/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

/* 7/12/2022 Expermineting with pulling the dates from the likes section. Unable to figure it out come... come back later */

class Likes {
    var id: String
    var audioID: String
    var Date: Date

    
    //initializing the audio variables
    init(id: String, audioID: String, Date: Date) {
        
        self.id = id
        self.audioID = audioID
        self.Date = Date
    }
    
    //passing in the audio variables to be published
    static func transformLikes(dict: [String: Any], keyId: String) -> Likes? {

        let date = (dict["Date"] as? Date)!
        let audioID = (dict["audioID"] as? String) == nil ? "" : (dict["audioID"]! as! String)
        
    let likes = Likes(id: keyId, audioID: audioID, Date: date)
        return likes
    }
    
    //Review the context of this function
    static func hash(forMembers members: [String]) -> String {
        let hash = members[0].hashString ^ members[1].hashString
        let memberHash = String(hash)
        return memberHash
    }
}

