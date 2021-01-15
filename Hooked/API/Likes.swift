//
//  Likes.swift
//  Hooked
//
//  Created by Michael Roundcount on 4/19/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

//each instance of this call holds an instance of a user from the database
class Likes {
    var uid: String
    var like: Bool?

    //teaching the class to create a new instance
    //We create an initializer. Assign each parameter to an instance variable
    init(uid: String, like: Bool) {
        self.uid = uid
        self.like = like
    }
}
