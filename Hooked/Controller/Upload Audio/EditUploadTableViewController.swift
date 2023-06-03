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

class EditUploadTableViewController: UITableViewController, UITextFieldDelegate {
    
    var audio: Audio!
    var audios: [Audio] = []
    
    public var StartTime: Double = 0.0
    public var StopTime: Double = 0.0
    
    var validationStatus: String = ""
    var previewValidationStatus: String = ""
    var popupContentController: DemoMusicPlayerController!
    
    let genre = ["Alternative Rock", /*"Ambient",*/ "Classical", "Country", "Dance & EDM", /*"Dancehall", "Deep House",*/ "Disco", /*"Drum & Bass", "Dubstep", "Electronic",*/ "Folk", "Hip-hop & Rap",/* "House",*/ "Indie", "Jazz & Blues", "Latin", "Metal", "Piano", "Pop", "R&B & Soul", "Reggae", "Reggaeton", "Rock", /*"Techno", "Trance", "Trap", "Triphop",*/ "World"]
    
    
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var lblBackground: UIView!
    
    
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
    @IBOutlet weak var previewBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        setupView()
        setUpUI()
        
        //Need to be able to modify this
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
        
        //Setting up the keyboard to dismiss
        titleTextField.returnKeyType = UIReturnKeyType.done
        self.titleTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        popupContentController.closeAction()
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
    
    //Setting up the keyboard to dismiss when clicking "Done"
    //https://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
    func textFieldShouldReturn(_ titleTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
            
            
            //Stopping the audio if it is already playing
            if popupContentController.player != nil {
                print("audio is playing... stopping it")
                popupContentController.player?.pause()
                popupContentController.player?.seek(to: .zero)
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
