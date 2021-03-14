//
//  AudioReportViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/16/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import UIKit

class AudioReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var audioTitleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var updateEmailTxt: UITextField!
    @IBOutlet weak var policyLbl: UILabel!
    
    var user: User!
    var users: [User] = []
    var audio: Audio!
    var inappropriateCheck: Bool = false
    var qualityCheck: Bool = false
    
    let report = ["This song is inappropriate (My filter is on)","This song's audio quality is very low"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setLabels()
        
        //Adjusting the keyboard when selecting a text field is selected
        //https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        tableView.tableFooterView = UIView()
        
        //Hiding these fields for now... they don't have use right now.
        userEmailLbl.isHidden = true
        updateEmailTxt.isHidden = true
        policyLbl.isHidden = true
    }
    
    func setupNavigationBar() {
        navigationItem.title = "File a report"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        let back = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = back
        
        let save = UIBarButtonItem(title: "Submit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(submitBtnDidTap))
        navigationItem.rightBarButtonItem = save
    }
    
    @objc func backBtnTapped(_ sender: UIBarButtonItem) {
        print("back")
        navigationController?.popViewController(animated: true)
    }
    @objc func submitBtnDidTap(_ sender: UIBarButtonItem) {
        print("saved")
        sendToFirebase()
        navigationController?.popViewController(animated: true)
    }
    
    //Dismissing the keyboard. Looks for the repsonder to the text field to give up the startis
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setLabels() {
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            self.audioTitleLbl.text = "You are filing a report against the song: '\(self.audio.title)' "
            self.artistLbl.text = "by: \(user.username)"
        }
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.userEmailLbl.text = "We have your email address as: '\(user.email)' if that is not the best way to contact you add an email address below: "
        }

        self.commentLbl.text = "Please add additional details:"
        self.commentField.layer.borderColor = UIColor.lightGray.cgColor
        self.commentField.layer.borderWidth = 1
        self.updateEmailTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.updateEmailTxt.layer.borderWidth = 1
        self.policyLbl.text = "We reviee each report. We will contact you at the email address provided"
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
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if cell.textLabel?.text == "This song is inappropriate (My filter is on)" {
                    inappropriateCheck = false
                }
                if cell.textLabel?.text == "This song's audio quality is very low" {
                    qualityCheck = false
                }
 
            } else {
                cell.accessoryType = .checkmark
                if cell.textLabel?.text == "This song is inappropriate (My filter is on)" {
                    inappropriateCheck = true
                }
                if cell.textLabel?.text == "This song's audio quality is very low" {
                    qualityCheck = true
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
        
            value["comment"] = self.commentField.text
            value["date"] = dateString

            Api.ReportFlag.uploadReportFlag(value: value)
        }
    }
}
