//
//  PushNotificationSender.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/5/23.
//  Copyright © 2023 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
class PushNotificationSender {
    
    // https://stackoverflow.com/questions/45678212/firebase-swift-send-a-push-notification-to-specific-user-given-device-token
    func sendPushNotification(payloadDict: [String: Any]) {
       let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
       var request = URLRequest(url: url)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // get your **server key** from your Firebase project console under **Cloud Messaging** tab
       request.setValue("key=AAAAfA6xuMg:APA91bG7X-3mxydxYXy2KaZye1ME2vuEV2p5ElPJWo_N7ePCwZV6JO8ub34w2nORx4Y4aekWvagyeIzVx2iL_72rdRLvwvSsA1sY9b2wkmI2dsOed0wBh_F7iRffXpCSm0f63wVVWOKi", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
       request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data, error == nil else {
            print(error ?? "")
            return
          }
          if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print(response ?? "")
          }
          print("Notfication sent successfully.")
          let responseString = String(data: data, encoding: .utf8)
          print(responseString ?? "")
       }
       task.resume()
    }
    
}
