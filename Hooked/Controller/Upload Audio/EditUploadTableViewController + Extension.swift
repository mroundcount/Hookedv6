//
//  EditUploadTableViewController + Extension.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

extension EditUploadTableViewController {

    func performChecks() {
        
        validationStatus = "Good"
        
        let startTimeMinString = startTimeMinTextField.text ?? "0"
        let startTimeSecString = startTimeSecTextField.text ?? "0"
        
        let startTimeMin: Double = startTimeMinString.toDouble() ?? 0
        let startTimeSec: Double = startTimeSecString.toDouble() ?? 0
        
        let startTime: Double = ((startTimeMin*60) + startTimeSec)
        
        let stopTimeMinString = stopTimeMinTextField.text ?? "0"
        let stopTimeSecString = stopTimeSecTextField.text ?? "0"
        
        let stopTimeMin: Double = stopTimeMinString.toDouble() ?? 0
        let stopTimeSec: Double = stopTimeSecString.toDouble() ?? 0
        
        let stopTime: Double = ((stopTimeMin*60) + stopTimeSec)
        print("Start Time: \(startTime)")
        print("Stop Time: \(stopTime)")
        
        let timeCheck = stopTime - startTime
        print("Time Check: \(timeCheck)")
        
        if timeCheck > 15 {
            validationStatus = "Fail"
            print(validationStatus)
            let alert = UIAlertController(title: "Too long", message: "Please keep the length of this clip to 15 seconds or less", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        if timeCheck < 5 && timeCheck >= 0 {
            validationStatus = "Fail"
            print(validationStatus)
            
            let alert = UIAlertController(title: "Too Short", message: "Come on pal give the people what they want, more than 5 seconds please", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        if timeCheck < 0 {
            validationStatus = "Fail"
            print(validationStatus)
            
            let alert = UIAlertController(title: "Whoa there", message: "You're start time is further along than your ending time", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            
        }
        
        if titleTextField.text == "" {
            validationStatus = "Fail"
            print(validationStatus)
            
            let alert = UIAlertController(title: "Whoa there", message: "Please enter a title for your masterpiece", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            print("Please enter a title for your masterpiece")
        }
        
        if genreLbl.text == "Genre" {
            validationStatus = "Fail"
            print(validationStatus)
            
            let alert = UIAlertController(title: "Whoa there", message: "Please enter a genre for your masterpiece", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            print("No genre")
        }
        //https://stackoverflow.com/questions/5219379/how-to-get-the-duration-of-an-audio-file-in-ios
        let url = NSURL(string: audio.audioUrl)
        let asset = AVURLAsset(url: url as! URL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        if Int(startTime) > Int(audioDurationSeconds) {
            validationStatus = "Fail"
            print("Nicht Gut start time: \(Int(startTime)) and duration \(audioDurationSeconds)")
            
            let alert = UIAlertController(title: "Whoa there cowboy!", message: "The start time you selected is after the song has completed", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                print("Whatever dude!")
            }))
        }
    }
    
    
    func previewPerformChecks() {
        
        previewValidationStatus = "Good"
        
        let startTimeMinString = startTimeMinTextField.text ?? "0"
        let startTimeSecString = startTimeSecTextField.text ?? "0"
        
        let startTimeMin: Double = startTimeMinString.toDouble() ?? 0
        let startTimeSec: Double = startTimeSecString.toDouble() ?? 0
        
        let startTime: Double = ((startTimeMin*60) + startTimeSec)
        
        let stopTimeMinString = stopTimeMinTextField.text ?? "0"
        let stopTimeSecString = stopTimeSecTextField.text ?? "0"
        
        let stopTimeMin: Double = stopTimeMinString.toDouble() ?? 0
        let stopTimeSec: Double = stopTimeSecString.toDouble() ?? 0
        
        let stopTime: Double = ((stopTimeMin*60) + stopTimeSec)
        print("Start Time: \(startTime)")
        print("Stop Time: \(stopTime)")
        
        let timeCheck = stopTime - startTime
        print("Time Check: \(timeCheck)")
        
        if timeCheck > 15 {
            previewValidationStatus = "Fail"
            print(previewValidationStatus)
            let alert = UIAlertController(title: "Too long", message: "Please keep the length of this clip to 15 seconds or less", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        if timeCheck < 5 && timeCheck >= 0 {
            previewValidationStatus = "Fail"
            print(previewValidationStatus)
            
            let alert = UIAlertController(title: "Too Short", message: "Come on pal give the people what they want, more than 5 seconds please", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        if timeCheck < 0 {
            previewValidationStatus = "Fail"
            print(previewValidationStatus)
            
            let alert = UIAlertController(title: "Whoa there", message: "You're start time is further along than your ending time", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            
        }
        
        let url = NSURL(string: audio.audioUrl)
        let asset = AVURLAsset(url: url as! URL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        if Int(startTime) > Int(audioDurationSeconds) {
            previewValidationStatus = "Fail"
            print("Nicht Gut start time: \(Int(startTime)) and duration \(audioDurationSeconds)")
            
            let alert = UIAlertController(title: "Whoa there cowboy!", message: "The start time you selected is after the song has completed", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                print("Whatever dude!")
            }))
        }
    }
}

