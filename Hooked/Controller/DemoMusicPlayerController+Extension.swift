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

extension DemoMusicPlayerController {

    //This is the one we'll be using
    //https://mobikul.com/play-audio-file-save-document-directory-ios-swift/
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
                    //guard let player = self.audioPlayer else { return }
                    audioPlayer.prepareToPlay()
                    
                    
                    audioSettings()
                    audioPlayer.play()
                    
                    startTimer()
                    gotAudioLength()
                    
                    audioPlayer.delegate = self
                    
                    recordStatus = "Playing"
                    print("Status: \(recordStatus)")
                    print("playing \(audio.title)")
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                // if the file doesn't exist
            } else {
                // you can use NSURLSession.sharedSession to download the data asynchronously
                print("Have to download the URL")
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        
                        print("playing audio from the download file step")
                        self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                        //guard let player = self.audioPlayer else { return }
                        self.audioPlayer?.prepareToPlay()
                        
                        self.audioSettings()
                        self.audioPlayer?.play()
                        
                        self.startTimer()
                        self.gotAudioLength()
                        
                        self.recordStatus = "Playing"
                        print("Status: \(self.recordStatus)")
                        
                        //I removed the updare slider
                        //self.updateSlider()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        recordStatus = "Stopped"
        controlBtn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopTimer()
        print("Status: \(recordStatus)")
    }
    
    func replayAudio() {
        audioSettings()
        audioPlayer?.play()
        recordStatus = "Playing"
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        startTimer()
        print("Status: \(recordStatus)")
    }
    
    func playAudio() {
        audioSettings()
        audioPlayer?.play()
        recordStatus = "Playing"
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        startTimer()
        print("Status: \(recordStatus)")
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        recordStatus = "Paused"
        controlBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        stopTimer()
        print("Status: \(recordStatus)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.stop()
        recordStatus = "Finished"
        controlBtn.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        stopTimer()
        popupItem.rightBarButtonItems = [ playBtn , closeBtn ] as? [UIBarButtonItem]
        print("Status: \(recordStatus)")
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

