//
//  AudioRadarViewController + Card Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/9/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit


extension AudioRadarViewController {

    //confifure the card frame and pass in the user parameter and append it to the card array
    func setupCard(audio: Audio) {
        
        let card: AudioCard = UIView.fromNib()
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.audio = audio
        //passing the radar controller to the card object
        card.controller = self
        cards.append(card)
        
        //append the stack view of arrays
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        
        //allows us to see the full stack of the cards.
        //setupTransforms()
        
        //Removes audio that the logged in user already likes.
        Api.Audio.observeNewLike { (likedAudio) in
            self.likesCollection.append(likedAudio)
            if card.audio.id == likedAudio.id {
                print("preparing to remove liked audio: \(likedAudio.title)")
                card.removeFromSuperview()
                //self.updateCards(card: card)
                self.removeCards(card: card)
            }
        }
        //Removes audio published by the artist that is logged in.
        Api.Audio.loadAudioFile(artist: Api.User.currentUserId) { (userAudio) in
            //creates an array called "audioCollection" which containts all the audio files
            self.userCollection.append(userAudio)
            if card.audio.artist == userAudio.artist {
                print("preparing to remove atrist audio: \(userAudio.title)")
                card.removeFromSuperview()
                //self.updateCards(card: card)
                self.removeCards(card: card)
            }
        }
        
        //Checking user preferences and removing cards accordingly
        Api.Preferences.getUserPreferencesforSingleEvent(user: Api.User.currentUserId) { (preference) in
            if card.audio.genre == "Alternative Rock" && preference.alternativeRock == false {
                print("removing for genre conflight \(audio.title)")
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Ambient" && preference.ambient == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Classical" && preference.classical == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Country" && preference.country == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Dance & EDM" && preference.danceEDM == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Dancehall" && preference.dancehall == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Deep House" && preference.deepHouse == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Disco" && preference.disco == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Drum & Bass" && preference.drumBass == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Dubstep" && preference.dubstep == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Electronic" && preference.electronic == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Folk" && preference.folk == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Hip-hop & Rap" && preference.hipHopRap == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "House" && preference.house == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Indie" && preference.indie == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Jazz & Blues" && preference.jazzBlues == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Latin" && preference.latin == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Metal" && preference.metal == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Piano" && preference.piano == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Pop" && preference.pop == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "R&B & Soul" && preference.RBSoul == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Reggae" && preference.raggae == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Reggaeton" && preference.reggaeton == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Rock" && preference.rock == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Techno" && preference.techno == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Trance" && preference.trance == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Trap" && preference.trap == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "Triphop" && preference.triphop == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
            if card.audio.genre == "World" && preference.world == false {
                card.removeFromSuperview()
                self.removeCards(card: card)
            }
        }
                
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            //downloadFile(audio: audio)
            //testDownloadFile(audio: audio)
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
}
