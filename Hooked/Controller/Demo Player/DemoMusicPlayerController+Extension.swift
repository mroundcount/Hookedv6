//
//  DemoMusicPlayerController+Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/22/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

import CoreMedia

extension DemoMusicPlayerController {
    
    func downloadFile(audio: Audio) {
        print("In new method")
        print("The title is \(audio.title)")
        let url = NSURL(string: audio.audioUrl)
                
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        self.audioSettings()
        self.playAudio()
        //audioPlayer.currentTime = TimeInterval(startTime)
        self.startTimer()
        self.gotAudioLength()
        self.recordStatus = "Playing"
    }
    
    func playAudio() {
        audioSettings()
                
        player?.play()
        recordStatus = "Playing"
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        controlBtn.tintColor = UIColor.white
        popupItem.rightBarButtonItems = [ pauseBtn , closeBtn ] as? [UIBarButtonItem]
        startTimer()
        print("Status: \(recordStatus)")

        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func pauseAudio() {
        player?.pause()
        recordStatus = "Paused"
        controlBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        controlBtn.tintColor = UIColor.white
        popupItem.rightBarButtonItems = [ playBtn , closeBtn ] as? [UIBarButtonItem]
        stopTimer()
    }
    
    func stopAudio() {
        player?.pause()
        player?.seek(to: .zero)
        recordStatus = "Stopped"
        controlBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        controlBtn.tintColor = UIColor.white
        stopTimer()
    }
    
    @objc func audioPlayerDidFinishPlaying(note: NSNotification) {
        print("Finished")
        player?.pause()
        recordStatus = "Finished"
        controlBtn.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        controlBtn.tintColor = UIColor.white
        stopTimer()
        popupItem.rightBarButtonItems = [ replayBtn , closeBtn ] as? [UIBarButtonItem]
        print("Status: \(recordStatus)")
    }
    
    func replayAudio() {
        print("replay tapped")
        if previewStatus == "Preview" {
            player?.seek(to:CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: 1))
        } else {
            player?.seek(to:CMTimeMakeWithSeconds(Float64(0),preferredTimescale: 1))
        }
        playAudio()
        audioSettings()
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        controlBtn.tintColor = UIColor.white
        popupItem.rightBarButtonItems = [ pauseBtn , closeBtn ] as? [UIBarButtonItem]
        print("Status: \(recordStatus)")
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func startTimer() {
        DispatchQueue.main.async { [self] in
            print("in timer")
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
    
    func getLengthOfAudio() -> Float {
        if player != nil {
            if recordStatus == "Playing"{
                print("audio duration: \(String(describing: player?.currentItem?.asset.duration))")
                return Float(CMTimeGetSeconds((player?.currentItem!.asset.duration)!))
            }
        }
      return 0.0
      }
    
    func gotAudioLength() {
        self.length = Float(getLengthOfAudio())
        print("length from gotAudio\(String(describing: length))")
        self.slider.maximumValue = self.length!
        self.startTimer()
    }

    func getCurrentTime() -> TimeInterval {
        if player != nil {
            return (player?.currentItem?.currentTime().seconds) as! TimeInterval
        }
    return 0.0
    }
    
    @objc func updateSlider() {
        let prog = Float(getCurrentTime())
        
        if previewStatus == "Preview" {
            if prog > Float(stopTime) {
                player?.pause()
                stopTimer()
                
                recordStatus = "Finished"
                controlBtn.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
                stopTimer()
                popupItem.rightBarButtonItems = [ replayBtn , closeBtn ] as? [UIBarButtonItem]
                print("Status: \(recordStatus)")
            }
        }
                
        self.popupItem.progress = prog
        slider.value = prog
        print(slider.value)
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
            
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
}

