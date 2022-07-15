//
//  LikesAPI.swift
//  Hooked
//
//  Created by Michael Roundcount on 7/11/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import Foundation
import Firebase

/* 7/12/2022 Expermineting with pulling the dates from the likes section. Unable to figure it out come... come back later */
class LikesApi {
    
    func observeUsersLikes(onSuccess: @escaping(LikesCompletion)) {
        print("in new likes check")
        Ref().databaseRoot.child("likes").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
                dict.forEach({ (key, value) in
                    self.getUserLikesforSingleEvent(id: key, onSuccess: { (likes) in
                        onSuccess(likes)

                    })
                })
            }
        }
    }
    
    func getUserLikesforSingleEvent(id: String, onSuccess: @escaping(LikesCompletion)) {
        let ref = Ref().databaseSpecificAudio(id: id)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let likes = Likes.transformLikes(dict: dict, keyId: snapshot.key) {
                    onSuccess(likes)
                }
            }
        }
    }
}

typealias LikesCompletion = (Likes) -> Void
