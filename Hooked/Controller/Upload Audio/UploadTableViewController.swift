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

class UploadTableViewController: UITableViewController, UITextFieldDelegate {
    
    var audioUrl: URL?
    var storageID: String?
    var username: String?
    var users: [User] = []
    var startTime: Double = 0.0
    var stopTime: Double = 0.0
        
    var validationStatus: String = ""
    
    let genre = ["Alternative Rock", /*"Ambient",*/ "Classical", "Country", "Dance & EDM", /*"Dancehall", "Deep House",*/ "Disco", /*"Drum & Bass", "Dubstep", "Electronic",*/ "Folk", "Hip-hop & Rap",/* "House",*/ "Indie", "Jazz & Blues", "Latin", "Metal", "Piano", "Pop", "R&B & Soul", "Reggae", "Reggaeton", "Rock", /*"Techno", "Trance", "Trap", "Triphop",*/ "World"]
        
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var lblBackground: UIView!
    
    @IBOutlet weak var browseBtn: UIButton!

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
        
    @IBOutlet weak var explicitSegment: UISegmentedControl!
    
    
    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var rangeSlider: RangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupView()

        checkForAudioFile()
        //setUpSlider()
        
        //Setting up the keyboard to dismiss
        titleTextField.returnKeyType = UIReturnKeyType.done
        self.titleTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
    //unhide the navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
    
    @IBAction func backBtn(_ sender: Any) {
        //dismiss scene
        navigationController?.popViewController(animated: true)
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

    
    
    
    @IBAction func uploadBtnDidTap(_ sender: Any) {
        print("opening browser")
        pickDocument()
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        print("pushed")
        //ProgressHUD.show("Saving...")
        performChecks(url: audioUrl!)
        
        if validationStatus != "Fail" {
            print("Success")
            print("Going with upload")
            uploadDocument()
        } else {
            print("Upload failed")
        }
    }

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
        
        //Checking the file size
        let asset = AVURLAsset(url: url as! URL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = (url.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
        print("The file size raw is: \(fileSizeValue/1000000)")
        let MB = (fileSizeValue/1000000)
        print("The file size in MB: \(MB)")
        
        //Checking to make sure there is a file to be uploaded
        if MB > 10 {
            let alert = UIAlertController(title: "Whoa there", message: "Your file sizing is over 10MB. Please compress or select a shorter song for now", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        
        
        //Doing a file size check based on duration.
        if Int(audioDurationSeconds) > 360 {
            let alert = UIAlertController(title: "Whoa there", message: "Your song is over 6 minutes long. Please compress or select a shorter song for now", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        }
        

        else {
            print("File sizing checks out")
            self.audioUrl = url
            print("import result (not yet saved): \(url)")
            //Compressing the text so it concatinates out the middle
            self.fileNameLbl.numberOfLines = 1
            self.fileNameLbl.lineBreakMode = .byTruncatingMiddle
            self.fileNameLbl.adjustsFontSizeToFitWidth = false
            self.fileNameLbl.text = "\(url)"

            checkForAudioFile()
        }
    }
    
    func uploadDocument() {
        //https://stackoverflow.com/questions/51365956/swift-get-variable-in-function-from-another-function
        guard let url = audioUrl
            else {
                return
        }
        storageID = NSUUID().uuidString
        print("my audio URL will be \(url)")
        print("my audio ID will be \(storageID)")
        
        StorageService.saveAudioFile(url: url, id: storageID!, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFirebase(dict: dict)
                print(dict)
            }
        }) {
            (errorMessage) in
        }
        
        //Dismiss view controller here.
        //I added a delay because for some reason the observe audio function is being called multiple times for the new upload.... figure this out another time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_USER_PROFILE) as! UserProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
            //self.navigationController?.popViewController(animated: true)
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
        
        
        if explicitSegment.selectedSegmentIndex == 0 {
            value["explicit"] = false
        }
        if explicitSegment.selectedSegmentIndex == 1 {
            value["explicit"] = true
        }
                
        value["startTime"] = startTime
        value["stopTime"] = stopTime
        value["storageID"] = storageID
        value["source"] = "iOS App"
    
        print("my storage ID should be: \(String(describing: storageID))")
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


//Reference for checking the size of a file
//This was placed in the uploadDocument function
/*
var fileSize: Double = 0.0
var fileSizeValue = 0.0
try? fileSizeValue = (url.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
if fileSizeValue > 0.0 {
    fileSize = (Double(fileSizeValue) / (1024 * 1024))
}
print("The file size raw is: \(fileSizeValue/1000000)")
let MB = (fileSizeValue/1000000)
print("The file size in MB: \(MB)")

//Checking to make sure there is a file to be uploaded
if MB > 3 {
    let alert = UIAlertController(title: "Whoa there", message: "Your file sizing is over 10MB. Please compress or select a shorter song for now", preferredStyle: .alert)
    self.present(alert, animated: true)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
}
*/

