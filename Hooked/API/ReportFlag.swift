//
//  ReportFlag.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/18/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation

//Audio dictionary
class ReportFlag {
    var id: String
    var reporterID: String
    var reporterEmail: String
    var reporterEmailUpdate: String
    
    var reportedArtist: String
    var reportedTitle: String
    
    var inappropriate: Bool
    var quality: Bool
    var comment: String
    
    var date: Date

    
    //initializing the audio variables
    init(id: String, reporterID: String, reporterEmail: String, reporterEmailUpdate: String, reportedArtist: String, reportedTitle: String, inappropriate: Bool, quality: Bool, comment: String, date: Date) {
        
        self.id = id
        self.reporterID = reporterID
        self.reporterEmail = reporterEmail
        self.reporterEmailUpdate = reporterEmailUpdate
        self.reportedArtist = reportedArtist
        self.reportedTitle = reportedTitle
        self.inappropriate = inappropriate
        self.quality = quality
        self.comment = comment
        self.date = date

    }
    
    //passing in the audio variables to be published
    static func transformReportFlag(dict: [String: Any], keyId: String) -> ReportFlag? {
        
        let reporterID = (dict["reporterID"] as? String) == nil ? "" : (dict["reporterID"]! as! String)
        let reporterEmail = (dict["reporterEmail"] as? String) == nil ? "" : (dict["reporterEmail"]! as! String)
        let reporterEmailUpdate = (dict["reporterEmailUpdate"] as? String) == nil ? "" : (dict["reporterEmailUpdate"]! as! String)
        let reportedArtist = (dict["reportedArtist"] as? String) == nil ? "" : (dict["reportedArtist"]! as! String)
        let reportedTitle = (dict["reportedTitle"] as? String) == nil ? "" : (dict["reportedTitle"]! as! String)
        
        let inappropriate = dict["inappropriate"] as? Bool == nil ? false : (dict["inappropriate"]! as! Bool)
        let quality = dict["quality"] as? Bool == nil ? false : (dict["quality"]! as! Bool)

        let comment = (dict["comment"] as? String) == nil ? "" : (dict["comment"]! as! String)
        let date = (dict["date"] as? Date)!
                   
        let reportFlag = ReportFlag(id: keyId, reporterID: reporterID, reporterEmail: reporterEmail, reporterEmailUpdate: reporterEmailUpdate, reportedArtist: reportedArtist, reportedTitle: reportedTitle, inappropriate: inappropriate, quality: quality, comment: comment, date: date)
        return reportFlag
    }
    
    //Review the context of this function
    static func hash(forMembers members: [String]) -> String {
        let hash = members[0].hashString ^ members[1].hashString
        let memberHash = String(hash)
        return memberHash
    }
}

