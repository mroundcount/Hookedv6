//
//  EditUploadTableViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD
import MobileCoreServices
import AVFoundation
import ZMSwiftRangeSlider

import Foundation
import Firebase
import FirebaseDatabase



class EditUploadTableViewController: UITableViewController {
    
    var audio: Audio!
    var audios: [Audio] = []
    
    public var StartTime: Double = 0.0
    public var StopTime: Double = 0.0
    

    var validationStatus: String = ""
    var previewValidationStatus: String = ""
    
    let genre = ["Alternative Rock", /*"Ambient",*/ "Classical", "Country", "Dance & EDM", /*"Dancehall", "Deep House",*/ "Disco", /*"Drum & Bass", "Dubstep", "Electronic",*/ "Folk", "Hip-hop & Rap",/* "House",*/ "Indie", "Jazz & Blues", "Latin", "Metal", "Piano", "Pop", "R&B & Soul", "Reggae", "Reggaeton", "Rock", /*"Techno", "Trance", "Trap", "Triphop",*/ "World"]
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var genrePickerDidSelect: UIPickerView!
    @IBOutlet weak var genreLbl: UILabel!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var stopTimeLbl: UILabel!
    
    
    @IBOutlet weak var startTimeMinTextField: UITextField!
    @IBOutlet weak var startTimeSecTextField: UITextField!
    
    @IBOutlet weak var stopTimeMinTextField: UITextField!
    @IBOutlet weak var stopTimeSecTextField: UITextField!
    
    @IBOutlet weak var timeRequirementsLbl: UILabel!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var previewBtn: UIButton!
    
    
    var popupContentController: DemoMusicPlayerController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        setupView()
        //Need to be able to modify this
        enterAudioName()
        enterStartMinTime()
        enterStartSecTime()
        enterStopMinTime()
        enterStopSecTime()
        enterGenre()
        
        setUpRequirementsLbl()
        setUpStartTimeLbl()
        setUpStopTimeLbl()
        
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController

    }
       
    func setupView() {
        //dismiss they keyboard with a tap gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 300 // Move view x points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func backBtnDidTap(_ sender: Any) {
        print("cancel")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        //ProgressHUD.show("Saving...")
        performChecks()
        if validationStatus != "Fail" {
            print("Success")
            print("Going with update")
            updateAudio()
        } else {
            print("Upload failed")
        }
    }
    
    @IBAction func previewBtnDidTap(_ sender: Any) {
        print("Upload Preview Tapped")
        
        previewPerformChecks()
        
        if previewValidationStatus != "Fail" {
            print("Success")
            print("Going with preview")
            
            
            
            let startTimeMinString = startTimeMinTextField.text ?? "0"
            let startTimeSecString = startTimeSecTextField.text ?? "0"

            let startTimeMin: Double = startTimeMinString.toDouble() ?? 0
            let startTimeSec: Double = startTimeSecString.toDouble() ?? 0
            
            let StartTime: Double = ((startTimeMin*60) + startTimeSec)

            let stopTimeMinString = stopTimeMinTextField.text ?? "0"
            let stopTimeSecString = stopTimeSecTextField.text ?? "0"
            
            let stopTimeMin: Double = stopTimeMinString.toDouble() ?? 0
            let stopTimeSec: Double = stopTimeSecString.toDouble() ?? 0
            
            let StopTime: Double = ((stopTimeMin*60) + stopTimeSec)
            

            popupContentController.songTitle = audio.title
            Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
                self.popupContentController.artistName = user.username
                if user.profileImageUrl != "" {
                    let url = URL(string: user.profileImageUrl)
                    let data = try? Data(contentsOf: url!)
                    self.popupContentController.albumArt = UIImage(data: data!)!
                } else {
                    self.popupContentController.albumArt = UIImage(named: "default_profile")!
                }
            }
            popupContentController.downloadFilePreviewEdit(audio: audio, startTime: StartTime, stopTime: StopTime)
            popupContentController.popupItem.accessibilityHint = NSLocalizedString("Double Tap to Expand the Mini Player", comment: "")
            tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
            #if targetEnvironment(macCatalyst)
            
            tabBarController?.popupBar.inheritsVisualStyleFromDockingView = true
            #endif
            
            tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
            
            if #available(iOS 13.0, *) {
                tabBarController?.popupBar.tintColor = UIColor.label
            } else {
                //tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
                tabBarController?.popupBar.tintColor = UIColor(red: 160, green: 160, blue: 160, alpha: 1)
            }
            
            
            
        } else {
            print("Update failed")
        }
    }
    
    
    func observeData() {
        Api.Audio.getAudioInforSingleEvent(id: audio.id) { [self] (Audio) in
            print("The title: \(self.audio.title)")
        }
    }
    
    func enterAudioName() {
        let placeholderAttr = NSAttributedString(string: "\(audio.title)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        //titleTextField.attributedPlaceholder = placeholderAttr
        titleTextField.text = audio.title
        titleTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterGenre() {
        let placeholderAttr = audio.genre
        genreLbl.text = placeholderAttr
        genreLbl.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStartMinTime() {
        let startMin : Int = Int(audio.startTime/60)
        print("start min: \(startMin)")
        
        let placeholderAttr = NSAttributedString(string: "\(startMin)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        //startTimeMinTextField.attributedPlaceholder = placeholderAttr
        startTimeMinTextField.text = String(startMin)
        startTimeMinTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStartSecTime() {
        let startMin : Int = Int(audio.startTime/60)
        let startSec : Int = Int(audio.startTime - Double(startMin*60))
        print("start sec: \(startSec)")
        
        let placeholderAttr = NSAttributedString(string: "\(startSec)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        //startTimeSecTextField.attributedPlaceholder = placeholderAttr
        startTimeSecTextField.text = String(startSec)
        startTimeSecTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStopMinTime() {
        let stoptMin : Int = Int(audio.stopTime/60)
        print("start min: \(stoptMin)")
        
        let placeholderAttr = NSAttributedString(string: "\(stoptMin)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        //stopTimeMinTextField.attributedPlaceholder = placeholderAttr
        stopTimeMinTextField.text = String(stoptMin)
        stopTimeMinTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStopSecTime() {
        let stopMin : Int = Int(audio.stopTime/60)
        let stopSec : Int = Int(audio.stopTime - Double(stopMin*60))
        print("start sec: \(stopSec)")
        
        let placeholderAttr = NSAttributedString(string: "\(stopSec)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        //stopTimeSecTextField.attributedPlaceholder = placeholderAttr
        stopTimeSecTextField.text = String(stopSec)
        stopTimeSecTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func setUpRequirementsLbl() {
        timeRequirementsLbl.text = "Enter the start time and end time (seconds) for your song. Length must not be longer than 15 seconds"
    }
    
    func setUpStartTimeLbl() {
        startTimeLbl.text = "Starting Time: "
    }
    
    func setUpStopTimeLbl() {
        stopTimeLbl.text = "Stopping Time: "
    }
    
    
    func updateAudio() {
        //saving the updated text fields. We're going to be doing it the whole dictonary at a time
        var dict = Dictionary<String, Any>()
        /*
         if let email = emailTextField.text, !email.isEmpty {
             dict["email"] = email
         } */
        
        let startTimeMinString = startTimeMinTextField.text ?? "0"
        let startTimeSecString = startTimeSecTextField.text ?? "0"

        let startTimeMin: Double = startTimeMinString.toDouble() ?? 0
        let startTimeSec: Double = startTimeSecString.toDouble() ?? 0
        
        let StartTime: Double = ((startTimeMin*60) + startTimeSec)

        let stopTimeMinString = stopTimeMinTextField.text ?? "0"
        let stopTimeSecString = stopTimeSecTextField.text ?? "0"
        
        let stopTimeMin: Double = stopTimeMinString.toDouble() ?? 0
        let stopTimeSec: Double = stopTimeSecString.toDouble() ?? 0
        
        let StopTime: Double = ((stopTimeMin*60) + stopTimeSec)
        /*
        if let title = titleTextField.text, !title.isEmpty {
            dict["title"] = title
        } */
        Database.database().reference().root.child("audioFiles").child(audio.id).updateChildValues(["title": titleTextField.text! ])
        
        Database.database().reference().root.child("audioFiles").child(audio.id).updateChildValues(["genre": titleTextField.text! ])

        Database.database().reference().root.child("audioFiles").child(audio.id).updateChildValues(["genre": genreLbl.text! ])
        
        Database.database().reference().root.child("audioFiles").child(audio.id).updateChildValues(["startTime": StartTime ])
        
        Database.database().reference().root.child("audioFiles").child(audio.id).updateChildValues(["stopTime":StopTime ])
        

        //Dismiss view controller here. There is a delay so the changes have time to go up to firebase
        //Two seconds might be cuttin it close
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension EditUploadTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genre[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genreLbl.text = genre[row]
    }

}
