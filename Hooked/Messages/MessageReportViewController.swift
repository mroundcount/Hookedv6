//
//  MessgeReportViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/30/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import UIKit

class MessageReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var user: User!
    var users: [User] = []
    var message: Message!
    var inappropriateCheck: Bool = false
    
    let report = ["This message has inappropraite content"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        self.navigationController?.isNavigationBarHidden = true
        
        //Setting up the keyboard tap and dismiss so it does not interfier with other functions like the row selection.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        tableView.tableFooterView = UIView()
    }
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 100 // Move view x points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func dismissKeyboard() {
        commentField.endEditing(true)
    }

    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnDidTap(_ sender: Any) {
        print("saved")
        sendToFirebase()
        navigationController?.popViewController(animated: true)
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
                if cell.textLabel?.text == "This message contains inappropraite content" {
                    inappropriateCheck = false
                    print("click 2")
                }
 
            } else {
                cell.tintColor = checkColor
                cell.accessoryType = .checkmark
                if cell.textLabel?.text == "This message contains inappropraite content" {
                    inappropriateCheck = true
                    print("click 1")
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
            value["reportedSender"] = self.message.from
            
            value["reporterID"] = user.uid
            value["reporterEmail"] = user.email
            //value["reporterEmailUpdate"] = self.updateEmailTxt.text
            value["inappropriate"] = self.inappropriateCheck
            value["comment"] = self.commentField.text
            value["date"] = dateString

            Api.ReportFlag.uploadMessageReportFlag(value: value)
        }
    }
}
