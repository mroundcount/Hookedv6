//
//  AudioRadarViewController + ExtensionTest.swift
//  Hooked
//
//  Created by Michael Roundcount on 1/11/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

extension AudioRadarViewController {

    func downloadFile(audio: Audio) {
        
        loadingInidcator.startAnimating()
        print("The title is \(audio.title)")
        
        let url = NSURL(string: audio.audioUrl)
                
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        
        startTime = Int(audio.startTime)
        stopTime = Int(audio.stopTime)
        
        if proceed == 1 {
            playAudioFromBeginning()
        } else {
            print ("function stopped")
        }
    }
    
    
    @objc func playImgDidTap() {
        if recordStatus == "Playing" {
            pauseAudio()
        } else if recordStatus == "Paused" {
            playAudio()
        } else if recordStatus == "Finished" {
            //totalReplayAudio()
            //replayAudio()
        } else if recordStatus == "Stopped" {
            playAudioFromBeginning()
        }
    }
    
    func playAudioFromBeginning() {
        audioSettings()
        //loadingInidcator.stopAnimating()
        player?.play()
        player?.seek(to:CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: 1))
        startTimer()
        recordStatus = "Playing"
        playImg.isHidden = false
        playImg.image = UIImage(systemName: "pause.circle.fill")
        //stopImg.image = UIImage(named: "refresh_circle")
    }
    
    func playAudio() {
        player?.play()
        recordStatus = "Playing"
        playImg.image = UIImage(systemName: "pause.circle.fill")
        stopImg.image = UIImage(named: "refresh_circle")
    }
    
    func pauseAudio() {
        player?.pause()
        recordStatus = "Paused"
        playImg.image = UIImage(systemName: "play.circle.fill")
    }

    //Updated 12/17/2021 to utilize the audio button
    func stopAudio() {
        print ("actuall we're here")
        player?.pause()
        player?.seek(to: .zero)
        recordStatus = "Stopped"
        stopTimer()
        //playImg.isHidden = true
        playImg.image = UIImage(systemName: "play.circle.fill")
        stopImg.image = UIImage(named: "refresh_circle")
    }

  
    // 12/17/2021 Here is the update
    func audioPlayerDidFinishPlaying(note: NSNotification) {
        print("Here here here")
        player?.pause()
        player?.seek(to: .zero)
        recordStatus = "Finished"
        
        //playImg.isHidden = true
        playImg.isHidden = false
        playImg.image = UIImage(named: "play")
        //stopImg.image = UIImage(systemName: "arrow.uturn.left.circle")
        //stopImg.image = UIImage(named: "refresh_circle")
    }

    
    func startTimer() {
        print("in timer")
        DispatchQueue.main.async { [self] in
            if(timer == nil) {
                timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateSlider),
                userInfo: nil,
                repeats: true)
            }
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func getCurrentTime() -> TimeInterval {
        if player != nil {
            return (player?.currentItem?.currentTime().seconds) as! TimeInterval
        }
    return 0.0
    }
    
    @objc func updateSlider() {
        let prog = Float(getCurrentTime())
        
        if prog > Float(startTime) {
            loadingInidcator.stopAnimating()
            loadingInidcator.hidesWhenStopped = true
        }
        if prog > Float(stopTime) {
            stopAudio()
        }
    }
    
    
    func audioSettings() {
        //Playing the audio without the silencer being turned off
        //https://stackoverflow.com/questions/35289918/play-audio-when-device-in-silent-mode-ios-swift
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        //Enabling audio to play in the background
        //https://developer.apple.com/documentation/avfoundation/media_playback_and_selection/configuring_ios_and_tvos_audio_playback_behavior
        //https://stackoverflow.com/questions/30280519/how-to-play-audio-in-background-with-swift
        /*
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        } */
    }
}


