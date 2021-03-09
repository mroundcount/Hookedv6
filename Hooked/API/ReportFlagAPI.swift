//
//  ReportFlagAPI.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/18/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation

class ReportFlagApi {
    //Method to load reports to the "AudioFile" table.
    func uploadReportFlag(value: Dictionary<String, Any>) {
        let ref = Ref().databaseReportFlag()
        ref.childByAutoId().updateChildValues(value)
    }
}
