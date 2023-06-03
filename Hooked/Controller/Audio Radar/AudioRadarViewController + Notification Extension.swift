//
//  AudioRadarViewController + Notification Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/21/23.
//  Copyright © 2023 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging
import UserNotifications


extension AudioRadarViewController {

    //Check like count
    func likeCountCheck(card: AudioCard) {
        
        let ref = Database.database().reference().child("likesCount").child(card.audio.id)
        ref.observe(.value, with: { [self] (snapshot: DataSnapshot!) in
            
            self.likeCount = Int(snapshot.childrenCount)
            print("Song with the ID: \(card.audio.id) has: \(self.likeCount) likes")
            
            // toogle for testing
            //let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
            //self.beginPushSequence(artistId: card.audio.artist, message: message)
            
            switch self.likeCount {
            case 1:
                print("The song got it's first like")
                let message = "You're song \(card.audio.title) got it's first like!"
                self.beginPushSequence(artistId: card.audio.artist, message: message)

            case 5:
                print("The song has 5 likes")
                let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
                self.beginPushSequence(artistId: card.audio.artist, message: message)

            case 10:
                print("The song has 10 likes")
                let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
                self.beginPushSequence(artistId: card.audio.artist, message: message)
                
            case 25:
                print("The song has 25 likes")
                let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
                self.beginPushSequence(artistId: card.audio.artist, message: message)
                
            case 50:
                print("The song has 50 likes")
                let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
                self.beginPushSequence(artistId: card.audio.artist, message: message)
                
            case 100:
                print("The song has 100 likes")
                let message = "You're song \(card.audio.title) now has \(self.likeCount) likes"
                self.beginPushSequence(artistId: card.audio.artist, message: message)

            default:
                print("No new milestone")
                print("artistID: \(card.audio.artist)")
                return;
            }
        })
    }
    
    
    func beginPushSequence(artistId: String, message: String){
        // https://stackoverflow.com/questions/63618643/how-do-i-get-a-document-from-firebase-that-is-ordered-by-a-variable-documentnam
        let db = Firestore.firestore()
        let docRef = db.collection("users_table").document(artistId)
        print("push artistID: \(artistId)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
                
                if #available(iOS 16.0, *) {
                    let result = dataDescription.split(separator: ": ")
                    let result2 = result[1].split(separator: "]")
                    self.artistToken = String(result2[0]) as String
                    print("fcm token: \(self.artistToken)")
                    
                    let notifPayload: [String: Any] = [
                        "to": self.artistToken,"notification": [
                        "title":"Congratulations",
                        "body": message,
                        "badge":1,"sound":"default"]
                    ]
                    PushNotificationSender().sendPushNotification(payloadDict: notifPayload)
                    
                } else {
                    // Fallback on earlier versions
                }

            } else {
                print("Document does not exist")
            }
        }
    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
