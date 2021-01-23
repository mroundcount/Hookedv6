//
//  AudioRadarViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 6/30/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import GeoFire

import FirebaseDatabase
import ProgressHUD
import LNPopupController

import AVFoundation
import AVKit

//I don't need this now, but may need it later if we decide to add in geo aids.
//import CoreLocation
class AudioRadarViewController: UIViewController, AVAudioPlayerDelegate {
    //Will use for geo mappin in a later version
    //var myQuery: GFQuery!
    //var queryHandle: DatabaseHandle?
    
    var audioCollection: [Audio] = []
    var likesCollection: [Audio] = []
    var userCollection: [Audio] = []
    var cards: [AudioCard] = []
    
    //detecting the position of the card at it's inital position
    var cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!
    
    var audio: Audio!
    //var audioPlayer: AVAudioPlayer!
    //var audioPath: URL!
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    //Playback funtions
    var timer : Timer?
    var length : Float?
    var startTime : Int = 0
    var stopTime : Int = 0
    
    //Keeping track of the playing status
    var recordStatus: String = ""
    //For dismissing the popup bar if music is playing
    
    //Monitoring function used in DispatchQueue.
    var returned = true // assume success for all
    
    @IBOutlet weak var cardStack: UIView!
    @IBOutlet weak var nopeImg: UIImageView!
    @IBOutlet weak var stopImg: UIImageView!
    @IBOutlet weak var playImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var loadingInidcator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        loadingInidcator.stopAnimating()
        loadingInidcator.hidesWhenStopped = true
        
        audioCollection.removeAll()
        cards.removeAll()
        
        title = "Hooked"
        nopeImg.isUserInteractionEnabled = true
        let tapNopeImg = UITapGestureRecognizer(target: self, action: #selector(nopeImgDidTap))
        nopeImg.addGestureRecognizer(tapNopeImg)
        
        likeImg.isUserInteractionEnabled = true
        let tapLikeImg = UITapGestureRecognizer(target: self, action: #selector(likeImgDidTap))
        likeImg.addGestureRecognizer(tapLikeImg)
        
        stopImg.isUserInteractionEnabled = true
        let tapStopImg = UITapGestureRecognizer(target: self, action: #selector(stopImgDidTap))
        stopImg.addGestureRecognizer(tapStopImg)
        stopImg.image = UIImage(named: "refresh_circle")
        //This is the way that you use the built in images.. just for reference
        //stopImg.image = UIImage(systemName: "stop.circle")
        
        playImg.isUserInteractionEnabled = true
        let tapPlayImg = UITapGestureRecognizer(target: self, action: #selector(playImgDidTap))
        playImg.addGestureRecognizer(tapPlayImg)
        playImg.image = UIImage(systemName: "pause.circle")
        recordStatus = "Opening"
        
        likeImg.isHidden = false
        nopeImg.isHidden = false
        playImg.isHidden = false
        stopImg.isHidden = false
        
        //AVAudioSession.sharedInstance()
    }
    
    //diabling the title area and the navigation bar the bottom
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear")
        loadingInidcator.stopAnimating()
        loadingInidcator.hidesWhenStopped = true
        //stopAudio()
        testStopAudio()
        //Reset the audio collection for shuffling.
        reloadViewFromNib()
        findAudioFiles()
        
        likeImg.isHidden = false
        nopeImg.isHidden = false
        playImg.isHidden = false
        stopImg.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        testStopAudio()
    }
    
    //Returning all of the audio files available
    func findAudioFiles() {
        Api.Audio.observeAudio { (audio) in
            self.audioCollection.append(audio)
        }
        //Think about adding this to the main thread and not async... review later
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.shuffleAudio { (success) -> Void in
                if success {
                    print("shuffle complete")
                    //Sometime there is still not enough time for the card set up to complete, so adding this as a temporary measure
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.playTopCard()
                    }
                }
            }
        }
    }
    
    func shuffleAudio(completion: (_ success: Bool) -> Void) {
        audioCollection.shuffle()
        for audio in audioCollection {
            self.setupCard(audio: audio)
        }
        completion(true)
    }
    
    
    //saving only true like values to the firebase so can can just view them in a liked page.
    func saveLikesToFirebase(like: Bool, card: AudioCard) {
        Ref().databaseLikesForUser(uid: Api.User.currentUserId)
            .updateChildValues([card.audio.id: like]) { (error, ref) in
                if error == nil, like == true {
                }
            }
        //Adding this to get a tables of likes so that we can count them later
        Ref().databaseLikesCount(id: card.audio.id)
            .updateChildValues([Api.User.currentUserId: like]) { (error, ref) in
                if error == nil, like == true {
                }
            }
    }
    
    //move to the next card in the array
    func updateCards(card: AudioCard) {
        //use enumderated method to this
        for (index, c) in self.cards.enumerated() {
            if c.audio.id == card.audio.id {
                self.cards.remove(at: index)
            }
        }
        setupGestures()
        //Resetting the cards to show songs a user didn't like the last time around.
        checkCardCount()
    }
    
    //removing cards from the array based on preference and likes
    func removeCards(card: AudioCard) {
        //use enumderated method to this
        for (index, c) in self.cards.enumerated() {
            if c.audio.id == card.audio.id {
                self.cards.remove(at: index)
            }
        }
        //Resetting the cards to show songs a user didn't like the last time around.
        checkCardCount()
        //Adding in the setupGestures attributes that do not require it to play
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    
    //Looking to see if we have run out of cards
    func checkCardCount() {
        let card: AudioCard = UIView.fromNib()
        if cards.count == 0 {
            //stopAudio()
            //audioPlayer = nil
            testStopAudio()
            
            likeImg.isHidden = true
            nopeImg.isHidden = true
            playImg.isHidden = true
            stopImg.isHidden = true
            
            let alert = UIAlertController(title: "Whoa there cowboy!", message: "You've run out of songs. Start over or check your preferences", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            }))
        }
    }
    
    
    
    //adding the pan gesture to the next card in the array
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        //I think this is where we'll have to break it down
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
            //print("Playing the first card: \(String(describing: cards.first?.audio.title))")
            //downloadFile(audio: (cards.first?.audio)!)
            resetAudio()
            playTopCard()
        }
    }
    
    func playTopCard() {
        print("in top card function")
        testDownloadFile(audio: (cards.first?.audio)!)
    }
    
    func resetAudio() {
        print("Stopping Audio")
        player?.pause()
        player?.seek(to: .zero)
    }
    
    //creating swipe animation
    @objc func nopeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        //save it to the firstbase
        swipeAnimation(translation: -750, angle: -15)
        checkCardCount()
    }
    
    //creating swipe animation
    @objc func likeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        //save it to the firstbase
        //only saving likes to the liked table
        saveLikesToFirebase(like: true, card: firstCard)
        swipeAnimation(translation: 750, angle: 15)
        checkCardCount()
    }
    
    
    //actual animation for swiping
    func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        guard let firstCard = cards.first else {
            return
        }
        //take the card out of the array once it has been moved
        for (index, c) in self.cards.enumerated() {
            if c.audio.id == firstCard.audio.id {
                self.cards.remove(at: index)
                self.audioCollection.remove(at: index)
            }
        }
        
        //sets up the pan gesture if you use the button instead of the swipe gesture
        self.setupGestures()
        
        CATransaction.setCompletionBlock {
            
            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        firstCard.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    //all the responsibility of moving the card view is on this pan gesture
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! AudioCard
        //cg point value so we know where the card is being swiped
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
            
        //look where the card is moving in the gesture
        case .changed:
            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            
            if translation.x > 0 {
                // show like icon
                //dfading the icon in and out
                card.likeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX
                card.nopeView.alpha = 0
            } else {
                // show unlike icon
                card.nopeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX
                card.likeView.alpha = 0
            }
            //adding smoothness to the transition
            card.transform = self.transform(view: card, for: translation)
        //check where the card is at the end of the gestire and deciding to sent true of false to the database
        case .ended:
            //threshold for like
            if translation.x > 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    //setting the threshold for the card once it has been moved. If it moves past this point then we complete move it off the page
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x + 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                //saveToFirebase(like: true, card: card)
                //only saving likes to the liked table
                saveLikesToFirebase(like: true, card: card)
                //apply the same logic to the next card in the stact
                self.updateCards(card: card)
                
                return
            } else if translation.x < -75 {
                
                UIView.animate(withDuration: 0.3, animations: {
                    //get the card back to it's origional position if the threshold has not been met
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x - 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                
                //saveToFirebase(like: false, card: card)
                self.updateCards(card: card)
                
                return
            }
            
            //initialize the card position after release if a decision is not made
            UIView.animate(withDuration: 0.3) {
                card.center = self.cardInitialLocationCenter
                card.likeView.alpha = 0
                card.nopeView.alpha = 0
                card.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
    
    
    
    //tilting the card while swiping
    func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        //having the rotation at a negative anchors the card at the top instead of the bottom
        let rotation = -translation.x / (view.frame.width / 2)
        return moveBy.rotated(by: rotation)
    }
    
    //laying out the rest of the card list once the top card has been moved off the screen
    //This gives the cards layout showing the corners of the upcoming ones. Purely cosmetic
    //I am not using this
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            if i > 3 { return }
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            } else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            card.transform = transform
        }
    }
    
    //saving the true or false to the current user logged in
    //I don't know think we are actually using this.
    /*
     func saveToFirebase(like: Bool, card: AudioCard) {
     Ref().databaseActionForUser(uid: Api.User.currentUserId)
     .updateChildValues([card.audio.id: like]) { (error, ref) in
     if error == nil, like == true {
     }
     }
     } */
}

extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}

