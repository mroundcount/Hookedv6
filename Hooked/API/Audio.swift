//
//  Audio.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/8/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation

//Audio dictionary
class Audio {
    var id: String
    var storageID: String
    var source: String
    var artist: String
    var date: Double
    var title: String
    var genre: String
    var explicit: Bool?
    var audioUrl: String
    var startTime: Double
    var stopTime: Double
    
    //initializing the audio variables
    init(id: String, storageID: String, source: String, artist: String, date: Double, title: String, genre: String, explicit: Bool, audioUrl: String, startTime: Double, stopTime: Double) {
        self.id = id
        self.storageID = storageID
        self.source = source
        self.artist = artist
        self.date = date
        self.title = title
        self.genre = genre
        self.explicit = explicit
        self.audioUrl = audioUrl
        self.startTime = startTime
        self.stopTime = stopTime
    }
    
    //passing in the audio variables to be published
    static func transformAudio(dict: [String: Any], keyId: String) -> Audio? {
        guard let artist = dict["artist"] as? String,
            let date = dict["date"] as? Double,
            let startTime = dict["startTime"] as? Double,
            let stopTime = dict["stopTime"] as? Double else
            {
                return nil
            }
            let storageID = (dict["storageID"] as? String) == nil ? "" : (dict["storageID"]! as! String)
            let source = (dict["source"] as? String) == nil ? "" : (dict["source"]! as! String)
            let title = (dict["title"] as? String) == nil ? "" : (dict["title"]! as! String)
            let genre = (dict["genre"] as? String) == nil ? "" : (dict["genre"]! as! String)
            let explicit = dict["explicit"] as? Bool == nil ? false : (dict["explicit"]! as! Bool)
            let audioUrl = (dict["audioUrl"] as? String) == nil ? "" : (dict["audioUrl"]! as! String)
                   
    let audio = Audio(id: keyId, storageID: storageID, source: source, artist: artist, date: date, title: title, genre: genre, explicit: explicit, audioUrl: audioUrl, startTime: startTime, stopTime: stopTime)
        return audio
    }

    
    //Review the context of this function
    static func hash(forMembers members: [String]) -> String {
        let hash = members[0].hashString ^ members[1].hashString
        let memberHash = String(hash)
        return memberHash
    }
}

