//
//  UploadTableViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/8/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD
import MobileCoreServices
import AVFoundation
import ZMSwiftRangeSlider

class UploadTableViewController: UITableViewController {
    
    var audioUrl: URL?
    var audioName: String?
    var username: String?
    var users: [User] = []
    //If testing works, remove this
    var startingTime: Double = 0.0
    var stoppingTime: Double = 0.0
    //End
    var startTime: Double = 0.0
    var stopTime: Double = 0.0
    
    var validationStatus: String = ""
    
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

    @IBOutlet weak var rangeSlider: RangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        enterAudioName()
        
        enterStartMinTime()
        enterStartSecTime()
        
        enterStopMinTime()
        enterStopSecTime()
        
        setUpRequirementsLbl()
        setUpStartTimeLbl()
        setUpStopTimeLbl()
        checkForAudioFile()
        //setUpSlider()
    }
    
    func checkForAudioFile() {
        if fileNameLbl.text == "Select MP3 File" {
            saveBtn.isEnabled = false
        } else {
            saveBtn.isEnabled = true
        }
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
    
    @IBAction func uploadBtnDidTap(_ sender: Any) {
        print("opening browser")
        pickDocument()
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        //ProgressHUD.show("Saving...")
        performChecks()
        
        if validationStatus != "Fail" {
            print("Success")
            print("Going with upload")
            uploadDocument()
        } else {
            print("Upload failed")
        }
    }
    

    
    func enterAudioName() {
        let placeholderAttr = NSAttributedString(string: "Song Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        titleTextField.attributedPlaceholder = placeholderAttr
        titleTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStartMinTime() {
        let placeholderAttr = NSAttributedString(string: "Min", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        startTimeMinTextField.attributedPlaceholder = placeholderAttr
        startTimeMinTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStartSecTime() {
        let placeholderAttr = NSAttributedString(string: "Sec", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        startTimeSecTextField.attributedPlaceholder = placeholderAttr
        startTimeSecTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStopMinTime() {
        let placeholderAttr = NSAttributedString(string: "Min", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        stopTimeMinTextField.attributedPlaceholder = placeholderAttr
        stopTimeMinTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
    
    func enterStopSecTime() {
        let placeholderAttr = NSAttributedString(string: "Sec", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        stopTimeSecTextField.attributedPlaceholder = placeholderAttr
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
    
    /*
     // Inactive for now until I can figure out how to place the min and max values as the start and stop time as well as figure out a way to get the full audio length
     
     //https://github.com/nanjingboy/ZMSwiftRangeSlider
     func setUpSlider() {
     rangeSlider.setValueChangedCallback { (minValue, maxValue) in
     print("rangeSlider1 min value:\(minValue)")
     print("rangeSlider1 max value:\(maxValue)")
     }
     rangeSlider.setMinValueDisplayTextGetter { (minValue) -> String? in
     self.startingTime = Double(minValue)
     print(self.startingTime)
     return "\(minValue)"
     }
     rangeSlider.setMaxValueDisplayTextGetter { (maxValue) -> String? in
     self.stoppingTime = Double(maxValue)
     print(self.stoppingTime)
     return "\(maxValue)"
     }
     rangeSlider.setMinAndMaxRange(10, maxRange: 90)
     } */
}

extension UploadTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension UploadTableViewController: UIDocumentPickerDelegate {
    //setting docuementTyle limitation to only open MP3s
    func pickDocument() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //ProgressHUD.show("Uploading...")
        guard let url = urls.first
            else {
                return
        }
        
        self.audioUrl = url
        print("import result (not yet saved): \(url)")
        //Compressing the text so it concatinates out the middle
        self.fileNameLbl.numberOfLines = 1
        self.fileNameLbl.lineBreakMode = .byTruncatingMiddle
        self.fileNameLbl.adjustsFontSizeToFitWidth = false
        self.fileNameLbl.text = "\(url)"
        
        //Checking to make sure there is a file to be uploaded
        checkForAudioFile()
    }
    
    func uploadDocument() {
        //https://stackoverflow.com/questions/51365956/swift-get-variable-in-function-from-another-function
        guard let url = audioUrl
            else {
                return
        }
        let audioName = NSUUID().uuidString
        print("my audio URL will be \(url)")
        print("my audio ID will be \(audioName)")
        
        StorageService.saveAudioFile(url: url, id: audioName, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFirebase(dict: dict)
                print(dict)
            }
        }) {
            (errorMessage) in
        }
        
        //Dismiss view controller here.
        //I added a delay because for some reason the obser audio function is being called multiple times for the new upload.... figure this out another time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    func documentMenu(_ documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func sendToFirebase(dict: Dictionary<String, Any>) {

        //Converting the start and stop time to a Double
        //See extension at the bottom
        
        /*
        Old Method
        let stopTimeString = stopTimeTextField.text
        let stopTime: Double = stopTimeString!.toDouble()!
        */

        //https://stackoverflow.com/questions/33704961/how-do-i-convert-a-textfields-string-to-a-double-in-xcode-with-swift
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
        
        
        let timeCheck = stopTime - stopTime
        print("Here")
        print("Time Check: \(timeCheck)")
        
        let date: Double = Date().timeIntervalSince1970
        var value = dict
        
        value["artist"] = Api.User.currentUserId
        value["date"] = date
        value["read"] = true
        value["title"] = titleTextField.text
        value["genre"] = genreLbl.text
        
        value["startTime"] = startTime
        value["stopTime"] = stopTime
        
        //Old method that writes to 'audio'
        //Api.Audio.uploadAudio(artist: Api.User.currentUserId, value: value)
        
        //New method that only writes to 'audioFile'
        Api.Audio.uploadAudioFile(value: value)
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

