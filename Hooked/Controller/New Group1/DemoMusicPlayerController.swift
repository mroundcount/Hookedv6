//
//  DemoMusicPlayerController.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/16/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController
import AVFoundation
import AVKit

import Firebase

class DemoMusicPlayerController: UIViewController, AVAudioPlayerDelegate {
    
    var audio: Audio!
    var audioPlayer: AVAudioPlayer!
    var audioPath: URL!
    var length : Float?
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    @IBOutlet weak var controlBtn: UIButton!
    @IBOutlet weak var previewControlBtn: UIButton!
    
    let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    
    var timer : Timer?
    var pauseBtn : UIBarButtonItem!
    var playBtn : UIBarButtonItem!
    var closeBtn : UIBarButtonItem!
    var replayBtn: UIBarButtonItem!
    var recordStatus: String = ""
    
    var previewStatus: String = ""
    
    var startTime : Int = 0
    var stopTime : Int = 0
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    var songTitle: String = "" {
        didSet {
            if isViewLoaded {
                songNameLabel.text = songTitle
            }
            popupItem.title = songTitle
        }
    }
    
    var artistName: String = "" {
        didSet {
            if isViewLoaded {
                artistNameLabel.text = artistName
            }
            popupItem.subtitle = artistName
        }
    }
    
    var albumTitle: String = "" {
        didSet {
            if isViewLoaded {
                albumNameLabel.text = albumTitle
            }
        }
    }
    
    var albumArt: UIImage = UIImage() {
        didSet {
            if isViewLoaded {
                albumArtImageView.image = albumArt
            }
            popupItem.image = albumArt
            popupItem.accessibilityImageLabel = NSLocalizedString("Album Art", comment: "")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        songNameLabel.text = songTitle
        artistNameLabel.text = artistName
        albumNameLabel.text = albumTitle
        albumArtImageView.image = albumArt
        
        if #available(iOS 13.0, *) {
            albumArtImageView.layer.cornerCurve = .continuous
        }
        albumArtImageView.layer.cornerRadius = 16
        
        //timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(DemoMusicPlayerController._timerTicked(_:)), userInfo: nil, repeats: true)
        
        pauseBtn = UIBarButtonItem(image: UIImage(named: "pause"), style: .plain, target: self, action: #selector(pauseAction))
        playBtn = UIBarButtonItem(image: UIImage(named: "play"), style: .plain, target: self, action: #selector(playAction))
        closeBtn = UIBarButtonItem(image: UIImage(named: "close-1"), style: .plain, target: self, action: #selector(closeAction))
        replayBtn = UIBarButtonItem(image: UIImage(named: "play"), style: .plain, target: self, action: #selector(replayAction))
        popupItem.rightBarButtonItems = [ pauseBtn, closeBtn ]
        //Trying to get the progress bar to appear
        
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        AVAudioSession.sharedInstance()
    }
    
    
    @IBAction func controlBtn(_ sender: UIButton) {
        print(recordStatus)
        if recordStatus == "Playing" {
            controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            pauseAudio()
            
        } else if recordStatus == "Paused" {
            controlBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            print("Starting the player again")
            playAudio()
            
        } else if recordStatus == "Finished" {
            
            print("Starting over")
            replayAudio()
            
        } else {
            print("Nothing happening here")
        }
    }
    
    
    func updateProgressBar(progress: Float) {
        print("Calling update bar")
        //self.popupItem.updateProgress(progress: progress)
        //self.tabBar.updateProgress(progress: progress)
    }
    
    @objc func pauseAction() {
        recordStatus = "Paused"
        //audioPlayer!.pause()
        pauseAudio()
        popupItem.rightBarButtonItems = [ playBtn , closeBtn ] as? [UIBarButtonItem]
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        stopTimer()
    }
    
    @objc func playAction() {
        recordStatus = "Playing"
        player?.play()
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        popupItem.rightBarButtonItems = [ pauseBtn , closeBtn ] as? [UIBarButtonItem]
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        startTimer()
    }
    
    @objc func replayAction() {
        recordStatus = "Playing"
        player?.seek(to:CMTimeMakeWithSeconds(Float64(0),preferredTimescale: 1))
        print("play action")
        if previewStatus == "Preview" {
            player?.seek(to:CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: 1))
        }
        playAudio()
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        popupItem.rightBarButtonItems = [ pauseBtn , closeBtn ] as? [UIBarButtonItem]
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        startTimer()
    }
    
    @objc func closeAction() {
        print("close action")
        //audioPlayer?.stop()
        self.dismissPopup()
        stopTimer()
        player?.pause()
        player?.seek(to: .zero)
    }
    
    func dismissPopup() {
        //presented = false
        popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
    }
    

    @IBAction func changeAudioTime(_ sender: Any) {
        print("grabbing slider")
        //audioPlayer.stop()
        //audioPlayer.currentTime = TimeInterval(slider.value)
        //after the time is changed we want it to start playing again
        //audioPlayer.prepareToPlay()
        //audioPlayer.play()
        //https://medium.com/@santoshkumarjm/how-to-design-a-custom-avplayer-to-play-audio-using-url-in-ios-swift-439f0dbf2ff2
        
        player?.pause()
        stopTimer()
        
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
            startTimer()
        }
    }
}
