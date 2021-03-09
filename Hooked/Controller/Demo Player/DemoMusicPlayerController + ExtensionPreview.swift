//
//  DemoMusicPlayerController + ExtensionPreview.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/30/20.
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
    
    
    func downloadFilePreview(audio: Audio) {
        print("In new method")
        print("The title is \(audio.title)")
        let url = NSURL(string: audio.audioUrl)
                
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        
        startTime = Int(audio.startTime)
        stopTime = Int(audio.stopTime)
        
        previewStatus = "Preview"
        
        if previewStatus == "Preview" {
            player?.seek(to:CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: 1))
        }
        
        self.audioSettings()
        self.playAudio()
        self.startTimer()
        self.gotAudioLength()
        self.recordStatus = "Playing"
    }
    
    
    
        
    func downloadFilePreviewEdit(audio: Audio, startTime: Double, stopTime: Double) {
        print("In new method")
        print("The title is \(audio.title)")
        let url = NSURL(string: audio.audioUrl)
                
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        self.startTime = Int(startTime)
        self.stopTime = Int(stopTime)

        previewStatus = "Preview"
        
        if previewStatus == "Preview" {
            player?.seek(to:CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: 1))
        }
        
        self.audioSettings()
        self.playAudio()
        self.startTimer()
        self.gotAudioLength()
        self.recordStatus = "Playing"
    }
    
    
    
    /*
    func downloadFilePreviewEdit(audio: Audio, startTime: Double, stopTime: Double) {
        let startTime = startTime
        let stopTime = stopTime
        
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
                    
                    print(startTime)
                    print(stopTime)
                    
                    self.startTime = Int(startTime)
                    self.stopTime = Int(stopTime)
                    
                    previewStatus = "Preview"
                    if previewStatus == "Preview" {
                        audioPlayer.currentTime = TimeInterval(startTime)
                    }
                    audioPlayer?.play()
                    startTimer()
                    gotAudioLength()
                    audioPlayer.delegate = self
                    recordStatus = "Playing"
                                        
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
                            //Using the variable as the integer to start and end the time
                            self.startTime = Int(startTime)
                            self.stopTime = Int(stopTime)
                            
                            previewStatus = "Preview"
                            if previewStatus == "Preview" {
                                audioPlayer.currentTime = TimeInterval(startTime)
                            }
                            audioPlayer?.play()
                            startTimer()
                            gotAudioLength()
                            audioPlayer.delegate = self
                            recordStatus = "Playing"
                            
                            
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
    */
    
    
    
    
    /*
    func previewStopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        recordStatus = "Stopped"
        previewControlBtn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        previewStopTimer()
        print("Status: \(recordStatus)")
    }
    
    func previewReplayAudio() {
        audioSettings()
        audioPlayer?.play()
        recordStatus = "Playing"
        previewControlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        previewStartTimer()
        print("Status: \(recordStatus)")
    }
    
    func previewPlayAudio() {
        audioSettings()
        audioPlayer.currentTime = TimeInterval(startTime)
        audioPlayer?.play()
        previewStartTimer()
        recordStatus = "Playing"
        print("Status: \(recordStatus)")
        //controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func previewPauseAudio() {
        audioPlayer?.pause()
        recordStatus = "Paused"
        previewControlBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        previewStopTimer()
        print("Status: \(recordStatus)")
    }
    
    func previewAudioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.stop()
        recordStatus = "Finished"
        previewControlBtn.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        previewStopTimer()
        popupItem.rightBarButtonItems = [ playBtn , closeBtn ] as? [UIBarButtonItem]
        print("Status: \(recordStatus)")
    }

    
    func previewStartTimer() {
        DispatchQueue.main.async { [self] in
            if(timer == nil) {
                timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(previewUpdateSlider),
                userInfo: nil,
                repeats: true)
            }
        }
    }
    
    func previewStopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func previewGetCurrentTime() -> TimeInterval {
        if audioPlayer != nil {
            if audioPlayer.isPlaying {
            return (audioPlayer.currentTime)
            }
        }
    return 0.0
    }
    
    func previewGetLengthOfAudio() -> TimeInterval {
          if audioPlayer != nil {
              if audioPlayer.isPlaying {
                  return audioPlayer.duration
              }
          }
      return 0.0
      }
    
    func previewGotAudioLength() {
        self.length = Float(previewGetLengthOfAudio())
        //print("length from gotAudio\(String(describing: length))")
        DispatchQueue.main.async {
            //self.slider.maximumValue = self.length!
            self.previewStartTimer()
        }
    }
    
    @objc func previewUpdateSlider() {
        let prog = Float(previewGetCurrentTime())
        if prog > Float(stopTime) {
            previewStopTimer()
        }
    }
    */
}


