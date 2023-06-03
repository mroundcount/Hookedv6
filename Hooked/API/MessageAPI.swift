//
//  MessageAPI.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/8/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import Foundation
import Firebase

class MessageApi {
    //func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
    //From origional video 34 with the extra to arguement.
    func sendMessage(from: String, value: Dictionary<String, Any>) {
        let ref = Ref().databaseMessageSendTo(from: from)
        ref.childByAutoId().updateChildValues(value)
    }
    
    
    //func receiveMessage(from: String, to: String, onSuccess: @escaping(Message) -> Void) {
    //From origional video 39 with the extra to arguement.

    func getMySentMessage(from: String, onSuccess: @escaping(Message) -> Void) {
        // Getting path from database
        let ref = Ref().databaseMessageSendTo(from: from)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                    onSuccess(message)
                }
            }
        }
    }
    
    
    
    func getMessagesforMe(from: String, onSuccess: @escaping(Message) -> Void) {
        //Setting the time limit
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            }
        
        print("DATE STAMP TEST: \(dayBefore)")
        // Getting path from database
        
        let ref = Ref().databaseMessageSendTo(from: from)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                    onSuccess(message)
                }
            }
        }
    }
}

