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
    
    
    func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }
        if ((cleanString.count) != 6) {
            return nil
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}


