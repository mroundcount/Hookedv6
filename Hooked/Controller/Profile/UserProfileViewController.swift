//
//  UserProfileViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/12/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import LNPopupController
import AVFoundation
import Foundation
import Firebase
import FirebaseDatabase

class UserProfileViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var optionsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var popupContentController: DemoMusicPlayerController!
    
    //Roundcount added 12/18 for popup
    //https://github.com/sdowless/PopUpWindow
    //https://www.youtube.com/watch?v=GIELUwI3qio
    lazy var popUpWindow: PopUpWindow = {
        
        let color = getUIColor(hex: "#1A1A1A")
        let borderColor = getUIColor(hex: "#66CD5D")
        
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.delegate = self
        view.backgroundColor = color
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.green.cgColor
        return view
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    var user: User?
    var users: [User] = []
    var audio = [Audio]()

    //var audioPlayer: AVAudioPlayer!
    
    var timer : Timer?
    var length : Float?
    
    var startTime : Int = 0
    var stopTime : Int = 0
    var recordStatus: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audio.removeAll()

        print("profile view did load")
        setUpUI()
            
        //removing the white menu at the top by hiding the same area.
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
        
        //Might be able to remove this
        AVAudioSession.sharedInstance()
        tableView.tableFooterView = UIView(frame: .zero)
        print("Users URL: \(user?.profileImageUrl)")
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.alpha = 0
        
        //Resetting Push notifications if applicable
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
 
    //Hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        print("profile view did appear")
        self.audio.removeAll()
        observeProfileData()
        observeAudioData()
    }
    
    //unhide the navigation bar
    //This is a temporary measure until I cn figure out how to only stop this player when the discover view controller is up.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        if popupContentController.player != nil {
            print("audio is playing")
            popupContentController.closeAction()
        }
    }

    @IBAction func uploadBtnDidPress(_ sender: UIButton) {
        //This function counts how many audio files have already been uploaded by a user. If it is more than 8 they are directed out.
        let ref = Database.database().reference().child("audioFiles")
        ref.queryOrdered(byChild: "artist").queryEqual(toValue: Api.User.currentUserId).observe(.value, with: { (snapshot: DataSnapshot!) in
            let count = snapshot.childrenCount
            print("uploads: \(count)")
            if count >= 8 {
                let alert = UIAlertController(title: "You are at your upload limit", message: "Sorry, but we are a small company with limited server space. As we grow you will be allowed to add more music.", preferredStyle: .alert)
                self.present(alert, animated: true)
                alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.cancel, handler: nil))
            } else {
                self.handleShowPopUp()
            }
        })
    }
    
    @IBAction func optionsBtnDidPress(_ sender: UIButton) {
        print("Option button tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usersAroundVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_EDIT_PROFILE) as! ProfileTableViewController
        self.navigationController?.pushViewController(usersAroundVC, animated: true)
    }

    
    func observeAudioData() {
        self.audio.removeAll()
        Api.Audio.loadAudioFile(artist: Api.User.currentUserId) { (audio) in
            //creates an array called "audioCollection" which containts all the audio files
            self.audio.append(audio)
            self.sortAudio()
            print("Returned Audio \(audio.title)")
            print("Observation complete")
        }
    }
    
    func sortAudio() {
        audio = audio.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audio.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioTableViewCell", for: indexPath) as! AudioTableViewCell
        cell.configureCell(uid: Api.User.currentUserId, audio: audio[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AudioTableViewCell
        print(cell.audio.title)
        popupContentController.songTitle = cell.audio.title
        Api.User.getUserInforSingleEvent(uid: cell.audio.artist) { (user) in
            self.popupContentController.artistName = user.username
            self.popupContentController.albumArt = user.profileImage
            if user.profileImageUrl != "" {
                let url = URL(string: user.profileImageUrl)
                let data = try? Data(contentsOf: url!)
                self.popupContentController.albumArt = UIImage(data: data!)!
            } else {
                self.popupContentController.albumArt = UIImage(named: "default_profile")!
            }
            //let url = URL(string: user.profileImageUrl)
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //self.popupContentController.albumArt = UIImage(data: data!)!
        }
        
        //Stopping the audio if it is already playing
        if popupContentController.player != nil {
            print("audio is playing... stopping it")
            popupContentController.player?.pause()
            popupContentController.player?.seek(to: .zero)
        }
        
        popupContentController.downloadFile(audio: audio[indexPath.row])
        popupContentController.popupItem.accessibilityHint = NSLocalizedString("Double Tap to Expand the Mini Player", comment: "")
        tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
        #if targetEnvironment(macCatalyst)
        tabBarController?.popupBar.inheritsVisualStyleFromDockingView = true
        #endif
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        if #available(iOS 13.0, *) {
            tabBarController?.popupBar.tintColor = UIColor.label
        } else {
            tabBarController?.popupBar.tintColor = UIColor(red: 160, green: 160, blue: 160, alpha: 1)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let preview = UITableViewRowAction(style: .normal, title: "      Preview     ") { [self] action, index in
            print("Preview")
            let cell = tableView.cellForRow(at: editActionsForRowAt) as? AudioTableViewCell
            print("Listening to: \(cell?.audio.id) which is titled \(cell?.audio.title)")
            
            //self.downloadFile(audio: (cell?.audio)!)
            self.popupContentController.songTitle = (cell?.audio.title)!
            Api.User.getUserInforSingleEvent(uid: (cell?.audio.artist)!) { (user) in
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
            
            popupContentController.downloadFilePreview(audio: (cell?.audio)!)
            self.popupContentController.popupItem.accessibilityHint = NSLocalizedString("Double Tap to Expand the Mini Player", comment: "")
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
            
            
            
        }
        preview.backgroundColor = .purple
        
        
        let edit = UITableViewRowAction(style: .normal, title: "      Edit     ") { action, index in
            let cell = tableView.cellForRow(at: editActionsForRowAt) as? AudioTableViewCell
            print("Editing: \(cell?.audio.id) which is titled \(cell?.audio.title)")
            
            
            Api.Audio.getAudioInforSingleEvent(id: (cell?.audio.id)!) { (audio) in
                print("title from profile: \(audio.title)")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let editAudioVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_EDIT_UPLOAD) as! EditUploadTableViewController
                editAudioVC.audio = audio
                self.navigationController?.pushViewController(editAudioVC, animated: true)
            }
            
        }
        edit.backgroundColor = .blue
        
        
        //copy this and add the variables in the return with "delete
        let delete = UITableViewRowAction(style: .normal, title: "      Delete     ") { action, index in
            
            
            let alert = UIAlertController(title: "Whoa there cowboy!", message: "Are you sure you want to delete this song?", preferredStyle: .alert)
            
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            
                let cell = tableView.cellForRow(at: editActionsForRowAt) as? AudioTableViewCell
                print("Removing \(cell?.audio.id) which is titled \(cell?.audio.title)")
                
                
                //FirebaseManager.shared.removePost(withID: (cell?.audio.id)!)
                //Trying to remove the reference of firebase.... it keeps failing
                let shared = FirebaseManager()
                //let reference = Database.database().reference()
                
                
                let storageURL = cell?.audio.audioUrl
                let storageURLDelete = storageURL?.subString(from:79,to:114)
                print("StorageURL: \(storageURL?.subString(from:79,to:114))")
                let desertRef = Ref().storageSpecificAudio(id: storageURLDelete!)
                // Delete the file
                desertRef.delete { error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                  } else {
                    // File deleted successfully
                  }
                }

                let selection = cell?.audio.id
                //Old method
                //let reference = Ref().databaseAudioArtist(artist: Api.User.currentUserId).child(selection!)
                let reference = Database.database().reference().child("audioFiles").child(selection!)
                print("Reference from deletion: \(reference)")
                //Test making the error optional
                reference.removeValue { error, _ in
                    print(error?.localizedDescription)
                }
                //Removing the audio from the like count node
                let countReference = Database.database().reference().child("likesCount").child(selection!)
                print("deleting audio from like count: \(reference)")
                //Test making the error optional
                countReference.removeValue { error, _ in
                    print(error?.localizedDescription)
                }
                //The table reload does not work for some reason
                self.viewDidAppear(true)
            }))
        }
        
        delete.backgroundColor = .red
        return [delete, edit, preview]
        
    }
    
    
    //I put this in the API folder... We might be able to remove it from there.
    func loadAudioFile(artist: String, onSuccess: @escaping(Audio) -> Void) {
           let ref = Database.database().reference().child("audioFiles")
           ref.queryOrdered(byChild: "artist").queryEqual(toValue: artist).observe(.childAdded, with: { snapshot in
               if let dict = snapshot.value as? [String : AnyObject] {
                   // do stuff with 'post' here.
                   if let audio = Audio.transformAudio(dict: dict, keyId: snapshot.key) {
                       onSuccess(audio)
                   }
               }
           })
       }
    
    
    //Roundcount added 12/18 for pop up window
    @objc func handleShowPopUp() {
        view.addSubview(popUpWindow)
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 34).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
        }
    }
    //End

}

extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex...endIndex])
    }
}


extension UserProfileViewController: PopUpDelegate {

    func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("Did remove pop up window..")
        }

    }
    
    func navigateToUpload() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let uploadVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_UPLOAD) as! UploadTableViewController
        self.navigationController?.pushViewController(uploadVC, animated: true)
        handleDismissal()
    }
    
    func navigateToWebsite() {
        if let url = NSURL(string: "https://hookedmusic.app/upload.html") {
            UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
        }
        handleDismissal()
    }
}



