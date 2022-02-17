//
//  AudioReportViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/16/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import UIKit

class AudioReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var complaintLbl: UILabel!
    @IBOutlet weak var audioTitleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var updateEmailTxt: UITextField!
    @IBOutlet weak var policyLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var user: User!
    var users: [User] = []
    var audio: Audio!
    var inappropriateCheck: Bool = false
    var qualityCheck: Bool = false
    var copyrightCheck: Bool = false
    
    let report = ["This song is explicit. My filter is on.","This song’s audio quality is poor.","I believe this song infringes copyright."]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        self.navigationController?.isNavigationBarHidden = true

        //Adjusting the keyboard when selecting a text field is selected
        //https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        tableView.tableFooterView = UIView()
        
        print("Cell Count: \(report.count)")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    @objc func backBtnTapped(_ sender: UIBarButtonItem) {
        print("back")
        navigationController?.popViewController(animated: true)
    }
     */
    
    @IBAction func submitBtnDidTap(_ sender: Any) {
        print("saved")
        sendToFirebase()
        navigationController?.popViewController(animated: true)
    }
    
    //Dismissing the keyboard. Looks for the repsonder to the text field to give up the startis
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        //self.view.frame.origin.y += 350+100 // Move view y points upward
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
        self.navigationController?.isNavigationBarHidden = false
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.count
    }
    
    //Loading the view with the current preferences
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = report[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Adding and removing values to the array
        //https://stackoverflow.com/questions/48845607/save-an-array-of-multiple-selected-uitableviewcell-values
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            let color = getUIColor(hex: "#1A1A1A")
            let checkColor = getUIColor(hex: "#66CD5D")
            cell.backgroundColor = color
            //making the checkmark green
            cell.tintColor = checkColor
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if cell.textLabel?.text == "This song is explicit. My filter is on." {
                    inappropriateCheck = false
                }
                if cell.textLabel?.text == "This song’s audio quality is poor." {
                    qualityCheck = false
                }
                if cell.textLabel?.text == "I believe this song infringes copyright." {
                    copyrightCheck = false
                }
 
            } else {
                cell.tintColor = checkColor
                cell.accessoryType = .checkmark
                if cell.textLabel?.text == "This song is explicit. My filter is on." {
                    inappropriateCheck = true
                }
                if cell.textLabel?.text == "This song’s audio quality is poor." {
                    qualityCheck = true
                }
                if cell.textLabel?.text == "I believe this song infringes copyright." {
                    copyrightCheck = true
                }
            }
        }
    }
    
    
    
    func sendToFirebase() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        var value = Dictionary<String, Any>()
        
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            value["reporterID"] = user.uid
            value["reporterEmail"] = user.email
        
            value["reporterEmailUpdate"] = self.updateEmailTxt.text
        
            value["reportedArtist"] = self.audio.artist
            value["reportedTitle"] = self.audio.title
        
            value["inappropriate"] = self.inappropriateCheck
            value["quality"] = self.qualityCheck
            value["copyright"] = self.copyrightCheck
        
            value["comment"] = self.commentField.text
            value["date"] = dateString

            Api.ReportFlag.uploadReportFlag(value: value)
        }
    }
}
