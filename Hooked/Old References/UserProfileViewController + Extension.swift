//
//  UserProfileViewController + Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/24/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//


/*
import Foundation
import UIKit
import LNPopupController
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

extension UserProfileViewController {
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
            print(destinationUrl)
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    audioPlayer.prepareToPlay()
                    startTime = Int(audio.startTime)
                    stopTime = Int(audio.stopTime)
                    playAudioFromBeginning()
                    audioPlayer.delegate = self
                                        
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
                            
                                self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                                self.audioPlayer.prepareToPlay()
                                self.startTime = Int(audio.startTime)
                                self.stopTime = Int(audio.stopTime)
                                self.playAudioFromBeginning()
                                self.audioPlayer.delegate = self
                            
                            
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

    func playAudioFromBeginning() {
        DispatchQueue.main.async { [self] in
            audioSettings()
            audioPlayer.currentTime = TimeInterval(startTime)
            print("Starting Time: \(startTime)")
            audioPlayer?.play()
            startTimer()
            recordStatus = "Playing"
            print("Status: \(recordStatus)")
        }
    }

    
    func startTimer() {
        DispatchQueue.main.async { [self] in
            print("in start timer")
            if(self.timer == nil) {
                print("start timer success")
                self.timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateSlider),
                userInfo: nil,
                repeats: true)
            } else {
                print("error in timer")
            }
        }
    }
    
    @objc func updateSlider() {
        let prog = Float(getCurrentTime())
        print(prog)
        if prog > Float(stopTime) {
            stopAudio()
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        recordStatus = "Stopped"
        stopTimer()
        print("Status: \(recordStatus)")
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.stop()
        recordStatus = "Finished"
        print("Status: \(recordStatus)")
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
        print("Made it here")
          if audioPlayer != nil {
              if audioPlayer.isPlaying {
                print("audio duration: \(audioPlayer.duration)")
                  return audioPlayer.duration
              }
          }
      return 0.0
      }
    
    func gotAudioLength() {
        self.length = Float(getLengthOfAudio())
        print("length from gotAudio\(String(describing: length))")
        DispatchQueue.main.async {
            //self.slider.maximumValue = self.length!
            self.startTimer()
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
*/
