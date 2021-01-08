//
//  AudioRadarViewController + Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 8/8/20.
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

extension AudioRadarViewController {
    
    //This is the one we'll be using
    //https://mobikul.com/play-audio-file-save-document-directory-ios-swift/
    
    
    func preDownloadFile(audio: Audio) {
        print("predownloading")
        let audioUrl = audio.audioUrl
        if audioUrl.isEmpty {
            return
        }
        if let audioUrl = URL(string: audioUrl) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                return
                // if the file doesn't exist
            } else {
                // you can use NSURLSession.sharedSession to download the data asynchronously
                print("Have to download the URL")
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { [self] (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        return
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                }).resume()
            }
        }
    }
    
    
    
    
    
    
    
    func downloadFile(audio: Audio) {
        
        let audioUrl = audio.audioUrl
        if audioUrl.isEmpty {
            return
        }
        
        if let audioUrl = URL(string: audioUrl) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    //guard let player = self.audioPlayer else { return }
                    audioPlayer.prepareToPlay()
                    //Look at this for experiment
                    startTime = Int(audio.startTime)
                    stopTime = Int(audio.stopTime)
                    playAudioFromBeginning()
                    
                    startTimer()
                    //gotAudioLength()
                    audioPlayer.delegate = self
                    print("playing \(audio.title)")
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                // if the file doesn't exist
            } else {
                // you can use NSURLSession.sharedSession to download the data asynchronously
                print("Have to download the URL")
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { [self] (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        
                        do {
                            print("playing audio from the download file step")
                            self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                            //guard let player = self.audioPlayer else { return }
                            
                            self.audioPlayer.prepareToPlay()
                            //Look at this for experiment
                            self.startTime = Int(audio.startTime)
                            self.stopTime = Int(audio.stopTime)
                            self.playAudio()
                            self.startTimer()
                            //gotAudioLength()
                            self.audioPlayer.delegate = self
                            print("playing \(audio.title)")

                        } catch let error {
                            print(error.localizedDescription)
                        }

                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
    }
    
    @objc func playImgDidTap() {
        if recordStatus == "Playing" {
            pauseAudio()
            
        } else if recordStatus == "Paused" {
            playAudio()
            
        } else if recordStatus == "Finished" {
            replayAudio()
            
        } else {
        }
    }
    
    
    @objc func stopImgDidTap() {
        totalReplayAudio()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        recordStatus = "Stopped"
        stopTimer()
        playImg.isHidden = true
        stopImg.image = UIImage(named: "refresh_circle")
    }
    
    func replayAudio() {
        downloadFile(audio: (cards.first?.audio)!)
        recordStatus = "Playing"
        playImg.isHidden = false
        playImg.image = UIImage(systemName: "pause.circle")
        stopImg.image = UIImage(named: "refresh_circle")
    }
    
    func totalReplayAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        downloadFile(audio: (cards.first?.audio)!)
        recordStatus = "Playing"
        //playImg.isHidden = false
        playImg.isHidden = false
        playImg.image = UIImage(systemName: "pause.circle")
    }
    
    func playAudioFromBeginning() {
        audioSettings()
        
        audioPlayer.currentTime = TimeInterval(startTime)
        audioPlayer?.play()
        recordStatus = "Playing"
        playImg.isHidden = false
        playImg.image = UIImage(systemName: "pause.circle")
        stopImg.image = UIImage(named: "refresh_circle")
    }
    
    func playAudio() {
        audioSettings()
        audioPlayer.currentTime = TimeInterval(startTime)
        audioPlayer?.play()
        recordStatus = "Playing"
        //playImg.isHidden = false
        DispatchQueue.main.async { [self] in
            playImg.image = UIImage(systemName: "pause.circle")
            stopImg.image = UIImage(named: "refresh_circle")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        recordStatus = "Paused"
        playImg.image = UIImage(systemName: "play.circle")
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.stop()
        recordStatus = "Finished"
        playImg.isHidden = true
        playImg.image = UIImage(named: "play")
        //stopImg.image = UIImage(systemName: "arrow.uturn.left.circle")
        stopImg.image = UIImage(named: "refresh_circle")
    }

    
    func startTimer() {
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
        if audioPlayer != nil {
            if audioPlayer.isPlaying {
            return (audioPlayer.currentTime)
            }
        }
    return 0.0
    }
    
    func getLengthOfAudio() -> TimeInterval {
          if audioPlayer != nil {
              if audioPlayer.isPlaying {
                  return audioPlayer.duration
              }
          }
      return 0.0
      }
    
    func gotAudioLength() {
        self.length = Float(getLengthOfAudio())
        //print("length from gotAudio\(String(describing: length))")
        DispatchQueue.main.async {
            //self.slider.maximumValue = self.length!
            self.startTimer()
        }
    }
    
    @objc func updateSlider() {
        let prog = Float(getCurrentTime())
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

