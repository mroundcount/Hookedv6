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
    
    //Roundcount Added
    var audio: Audio!
    var audioPlayer: AVAudioPlayer!
    var audioPath: URL!
    
    //var presented = false
    var length : Float?
    //End
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    @IBOutlet weak var controlBtn: UIButton!
    
    let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    
    var timer : Timer?
    var pauseBtn : UIBarButtonItem!
    var playBtn : UIBarButtonItem!
    var closeBtn : UIBarButtonItem!
    var recordStatus: String = ""
    
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
        popupItem.rightBarButtonItems = [ pauseBtn, closeBtn ]
        //Trying to get the progress bar to appear
        
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        controlBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        
        AVAudioSession.sharedInstance()
    }
    
    
    @IBAction func controlBtn(_ sender: UIButton) {
        print(recordStatus)
        if recordStatus == "Playing" {
            controlBtn.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            print("Pausing the player")
            pauseAudio()
            
        } else if recordStatus == "Paused" {
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
        print("pause action")
        audioPlayer!.pause()
        popupItem.rightBarButtonItems = [ playBtn , closeBtn ] as? [UIBarButtonItem]
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        stopTimer()
    }
    
    @objc func playAction() {
        print("play action")
        audioPlayer!.play()
        self.popupBar.progressViewStyle = LNPopupBarProgressViewStyle.bottom
        popupItem.rightBarButtonItems = [ pauseBtn , closeBtn ] as? [UIBarButtonItem]
        startTimer()
    }
    
    @objc func closeAction() {
        print("close action")
        audioPlayer!.stop()
        self.dismissPopup()
        stopTimer()
    }
    
    func dismissPopup() {
        //presented = false
        popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
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
            self.slider.maximumValue = self.length!
            self.startTimer()
        }
    }
    
    @objc func updateSlider() {
        let prog = Float(getCurrentTime()) / self.length!
        self.popupItem.progress = prog
        slider.value = Float(getCurrentTime())
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func startTimer() {
        if(timer == nil) {
            timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateSlider),
            userInfo: nil,
            repeats: true)
        }
    }
    
    
    func getCurrentTime() -> TimeInterval {
        if audioPlayer != nil {
            if audioPlayer.isPlaying {
                //here
                //print(audioPlayer.currentTime)
            return audioPlayer.currentTime
            }
        }
    return 0.0
    }
    
    @IBAction func changeAudioTime(_ sender: Any) {
        if let player = audioPlayer {
            player.stop()
            player.currentTime = TimeInterval(slider.value)
            //player.currentTime = TimeInterval(progressView.value)
            //after the time is changed we want it to start playing again
            player.prepareToPlay()
            player.play()
        }
    }
       
    /*
    @objc func _timerTicked(_ timer: Timer) {
        popupItem.progress += 0.0002;
        popupItem.accessibilityProgressLabel = NSLocalizedString("Playback Progress", comment: "")
        
        let totalTime = TimeInterval(250)
        popupItem.accessibilityProgressValue = "\(accessibilityDateComponentsFormatter.string(from: TimeInterval(popupItem.progress) * totalTime)!) \(NSLocalizedString("of", comment: "")) \(accessibilityDateComponentsFormatter.string(from: totalTime)!)"
        
        progressView.progress = popupItem.progress
        
        if popupItem.progress >= 1.0 {
            timer.invalidate()
            popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
        }
    }
    */
    
    
    
    
    
    
    
    
}
