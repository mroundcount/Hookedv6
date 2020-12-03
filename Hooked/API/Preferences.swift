//
//  Preferences.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/7/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

class Preferences {
    var user: String
    var alternativeRock: Bool?
    var ambient: Bool?
    var classical: Bool?
    var country: Bool?
    var danceEDM: Bool?
    var dancehall: Bool?
    var deepHouse: Bool?
    var disco: Bool?
    var drumBass: Bool?
    var dubstep: Bool?
    var electronic: Bool?
    var folk: Bool?
    var hipHopRap: Bool?
    var house: Bool?
    var indie: Bool?
    var jazzBlues: Bool?
    var latin: Bool?
    var metal: Bool?
    var piano: Bool?
    var pop: Bool?
    var RBSoul: Bool?
    var raggae: Bool?
    var reggaeton: Bool?
    var rock: Bool?
    var techno: Bool?
    var trance: Bool?
    var trap: Bool?
    var triphop: Bool?
    var world: Bool?
    
    init(user: String) {
        self.user = user
    }
    
    static func transformPreferences(dict: [String: Any]) -> Preferences? {
        print("In transformPreferences")

        let preference = Preferences (user: Api.User.currentUserId)
        
        if let alternativeRock = dict["Alternative Rock"] as? Bool {
            preference.alternativeRock = alternativeRock
        }
        if let ambient = dict["Ambient"] as? Bool {
            preference.ambient = ambient
        }
        if let classical = dict["Classical"] as? Bool {
            preference.classical = classical
        }
        if let country = dict["Country"] as? Bool {
            preference.country = country
        }
        if let danceEDM = dict["Dance & EDM"] as? Bool {
            preference.danceEDM = danceEDM
        }
        if let dancehall = dict["Dancehall"] as? Bool {
            preference.dancehall = dancehall
        }
        if let deepHouse = dict["Deep House"] as? Bool {
            preference.deepHouse = deepHouse
        }
        if let disco = dict["Disco"] as? Bool {
            preference.disco = disco
        }
        if let drumBass = dict["Drum & Bass"] as? Bool {
            preference.drumBass = drumBass
        }
        if let dubstep = dict["Dubstep"] as? Bool {
            preference.dubstep = dubstep
        }
        if let electronic = dict["Electronic"] as? Bool {
            preference.electronic = electronic
        }
        if let folk = dict["Folk"] as? Bool {
            preference.folk = folk
        }
        if let hipHopRap = dict["Hip-hop & Rap"] as? Bool {
            preference.hipHopRap = hipHopRap
        }
        if let house = dict["House"] as? Bool {
            preference.house = house
        }
        if let indie = dict["Indie"] as? Bool {
            preference.indie = indie
        }
        if let jazzBlues = dict["Jazz & Blues"] as? Bool {
            preference.jazzBlues = jazzBlues
        }
        if let latin = dict["Latin"] as? Bool {
            preference.latin = latin
        }
        if let metal = dict["Metal"] as? Bool {
            preference.metal = metal
        }
        if let piano = dict["Piano"] as? Bool {
            preference.piano = piano
        }
        if let pop = dict["Pop"] as? Bool {
            preference.pop = pop
        }
        if let piano = dict["Piano"] as? Bool {
            preference.piano = piano
        }
        if let RBSoul = dict["R&B & Soul"] as? Bool {
            preference.RBSoul = RBSoul
        }
        if let piano = dict["Piano"] as? Bool {
            preference.piano = piano
        }
        if let raggae = dict["Reggae"] as? Bool {
            preference.raggae = raggae
        }
        if let reggaeton  = dict["Reggaeton"] as? Bool {
            preference.reggaeton = reggaeton
        }
        if let rock = dict["Rock"] as? Bool {
            preference.rock = rock
        }
        if let techno = dict["Techno"] as? Bool {
            preference.techno = techno
        }
        if let trance = dict["Trance"] as? Bool {
            preference.trance = trance
        }
        if let trap = dict["Trap"] as? Bool {
            preference.trap = trap
        }
        if let triphop = dict["Triphop"] as? Bool {
            preference.triphop = triphop
        }
        if let world = dict["World"] as? Bool {
            preference.world = world
        }

        return preference
    }
}

extension Preferences: Equatable {
    static func == (lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.user == rhs.user
    }
}
