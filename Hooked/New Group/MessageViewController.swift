//
//  MessageViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/4/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import UIKit
import FirebaseAuth
import MobileCoreServices
import AVFoundation

class MessageViewController: UIViewController, UISearchResultsUpdating, MessageProfileNavigationDelegate {
    
    func didTapProfilePicture(message: Message!) {
        print("from the viewcontroller: \(message.from)")
        Api.User.getUserInforSingleEvent(uid: message.from) { (user) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            detailVC.user = user
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @IBOutlet weak var messageTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePartner: UIImage!
    //Referenced in video; probably not needed
    var partnerUsername: String!
    var placeholderLbl = UILabel()
    var picker = UIImagePickerController()
    var messages = [Message]()
    
    //Checking if the loading audio function should complete
    var myMessages : Int = 0
    var controller: MessageViewController!
    var searchResults: [Message] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.messageTypeSegmentedControl.selectedSegmentIndex == 0 {
            oberseveMessagesForMe()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
            cell.profileImage.isHidden = true
            observeMyMessages()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //Moving up the keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 280 // Move view x points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func segmentDidSwitch(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            oberseveMessagesForMe()
            myMessages = 0
        case 1:
            observeMyMessages()
            myMessages = 1
        default:
            oberseveMessagesForMe()
            myMessages = 0
        }
    }
    
    
    func observeMyMessages() {
        // Messages I have sent out
        self.messages.removeAll()
        Api.Message.getMySentMessage(from: Api.User.currentUserId) { (message) in
            print(message.text)
            self.messages.append(message)
            self.sortMessages()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if self.messages.count > 0 {
                self.checkLastMessageDate()
            } else {
                return
            }
         }
        textBackgroundView.isHidden = false
        inputTextView.isHidden = false
        sendBtn.isHidden = false
        
        self.tableView.reloadData()
    }
    
    func oberseveMessagesForMe() {
        // Message from folks I am following.
        self.messages.removeAll()
        Api.User.observeUsersIamFollowing { (following) in
            Api.Message.getMessagesforMe(from: following.uid) { (message) in
                //NOTE: We may have to put all of these into an array and sort, order there from there
                print("Message you would receive: \(message.text)")
                self.messages.append(message)
                self.sortMessages()
            }
        }
        textBackgroundView.isHidden = true
        inputTextView.isHidden = true
        sendBtn.isHidden = true
        
        self.tableView.reloadData()
    }
    
    func sortMessages() {
        messages = messages.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func checkLastMessageDate() {
        print("The last message I send was: \(messages.last?.text) on \(messages.last?.date)")
        let date = Date(timeIntervalSince1970: messages.last?.date ?? Date().timeIntervalSince1970)
        print("date: \(date)")
        
        let time1 = Date()
        let difference = Calendar.current.dateComponents([.hour, .minute], from: time1, to: date)
        //With minutes
        //let formattedString = String(format: "%02ld%02ld", difference.hour!, difference.minute!)
        let hourCheck = Int(difference.hour!) * -1
        let minuteCheck = Int(difference.minute!) * -1

        print("hours: \(hourCheck)")
        if hourCheck < 168 {
            print("LESS that one week")
            timeCriteriaNotMet()
        } else {
            print("MORE than one week")
        }
        
        /*
        print("minutes: \(minuteCheck)")
        if minuteCheck < 15 {
            print("LESS that one minute")
            timeCriteriaNotMet()
        } else {
            print("MORE than one minute")
        }
        */
        
    }
    
    func timeCriteriaNotMet() {
        let alert = UIAlertController(title: "Timing Alert", message: "You can only send one message to subscribers per week.", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        textBackgroundView.isHidden = true
        inputTextView.isHidden = true
        sendBtn.isHidden = true
    }
    
    @IBAction func sendBtnDidTapped(_ sender: Any) {
        if let text = inputTextView.text, text != "" {
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
            sendToFirebase(dict: ["text": text as Any])
            self.viewWillAppear(true)
        }
    }
    
    func sendToFirebase(dict: Dictionary<String, Any>) {
        let date: Double = Date().timeIntervalSince1970
        var value = dict
        value["from"] = Api.User.currentUserId
        //value["to"] = partnerId
        value["date"] = date
        value["read"] = true
        //Full method from the first from video 34
        //Api.Message.sendMessage(from: Api.User.currentUserId, to: partnerId, value: value)
        Api.Message.sendMessage(from: Api.User.currentUserId, value: value)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            //once we have the search convert it to lower case
            let textLowercased = searchController.searchBar.text!.lowercased()
            filerContent(for: textLowercased)
        }
        tableView.reloadData()
    }
    
    func filerContent(for searchText: String) {
        searchResults = self.messages.filter {
            return $0.text.lowercased().range(of: searchText) != nil
        }
    }
}

// Show the placeholder value if the text is empty; otherwise, we will hide the placeholder all together.
extension MessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("Text filling")
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            let text = textView.text.trimmingCharacters(in: spacing)
            sendBtn.isEnabled = true
            let color = getUIColor(hex: "#66CD5D")
            sendBtn.setTitleColor(color, for: UIControl.State.normal)
            placeholderLbl.isHidden = true
        //If the text view is empty we'll also hide the send button.
        } else {
            print("Text empty")
            sendBtn.isEnabled = false
            sendBtn.setTitleColor(.black, for: UIControl.State.normal)
            placeholderLbl.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        //print("Number of characters: \(numberOfChars)")
        
        if numberOfChars >= 100 {
            //Disable send button
            sendBtn.isEnabled = false
            sendBtn.setTitleColor(.black, for: UIControl.State.normal)
            
            // create the alert
            let alert = UIAlertController(title: "Character Alert", message: "Please keep messages to less than 100 characters", preferredStyle: UIAlertController.Style.alert)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        return numberOfChars < 100
    }
}


extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return self.messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        cell.configureCell(uid: Api.User.currentUserId, message: messages[indexPath.row])
        cell.MessageProfileNavigationDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.backgroundColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let message = messages[indexPath.row]
        let text = message.text
        if !text.isEmpty {
            height = text.estimateFrameForText(text).height + 60
        }
        
        let heightMessage = message.height
        let widthMessage = message.width
        if heightMessage != 0, widthMessage != 0 {
            height = CGFloat(heightMessage / widthMessage * 250)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //copy this and add the variables in the return with "delete
        
        if myMessages == 1 {
            let delete = UITableViewRowAction(style: .normal, title: "      Delete     ") { action, index in
                let cell = tableView.cellForRow(at: editActionsForRowAt) as? MessageTableViewCell
                print("Removing \(cell?.message.id) which is titled \(cell?.message.text)")
                
                //Testing if this works.
                let selection = cell?.message.id
                let reference = Ref().databaseMessageSendTo(from: Api.User.currentUserId).child(selection!)
                
                print("Reference from deletion: \(reference)")
                reference.removeValue { error, _ in
                    print(error?.localizedDescription)
                }
                //The table reload does not work for some reason
                self.viewDidAppear(true)
            }
            self.tableView.reloadData()
            delete.backgroundColor = .red
            return [delete]

        } else {
            let report = UITableViewRowAction(style: .normal, title: "      Report     ") { action, index in
                let cell = tableView.cellForRow(at: editActionsForRowAt) as? MessageTableViewCell
                print("Removing \(cell?.message.id) which is titled \(cell?.message.text)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let reportVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_MESSAGE_REPORT) as! MessageReportViewController
                reportVC.message = cell?.message
                
                self.navigationController?.pushViewController(reportVC, animated: true)
                }
            report.backgroundColor = .purple
            return [report]
        }
    }
}
