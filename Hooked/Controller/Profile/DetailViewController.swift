//
//  DetailViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import CoreLocation
import LNPopupController
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var subscriptionBtn: UIButton!
    
    var popupContentController: DemoMusicPlayerController!
    
    var user: User!
    var users: [User] = []
    var audio = [Audio]()
    var subscribedCollection: [User] = []
    var subscribed : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        setUpUI()
        
        //Hiding subscription button for now.
        subscriptionBtn.isHidden = true
        subscriptionBtn.isEnabled = false
        
        //removing the white menu at the top by hiding the same area.
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
        
        //Might be able to remove this
        AVAudioSession.sharedInstance()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    //Hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //unhide the navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        
        //This is a temporary measure until I cn figure out how to only stop this player when the discover view controller is up.
        if popupContentController.player != nil {
            popupContentController.closeAction()
        }
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        //dismiss scene
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscriptionBtnDidTap(_ sender: Any) {
        if self.subscribed == 1 {
            print("Unfollowing: \(self.user.username)")
            unfollow()
        } else {
            print("Now following: \(self.user.username)")
            AddSubscription(subscribe: Date().timeIntervalSince1970)
        }
    }
    
    func AddSubscription(subscribe: Double) {
        Ref().databaseFollowingForUser(uid: Api.User.currentUserId)
            .updateChildValues([user.uid: subscribe]) { (error, ref) in
                if error == nil, subscribe == Date().timeIntervalSince1970{
                }
            }
        //The artist is gaining a new follower!!!!!!!
        Ref().databaseFollowersForUser(uid: user.uid)
            .updateChildValues([Api.User.currentUserId: subscribe]) { (error, ref) in
                if error == nil, subscribe == Date().timeIntervalSince1970{
                }
            }
    }
    
    func unfollow() {
        //Removing from THEIR followers list
        let following = Ref().databaseFollowersForUser(uid: user.uid).child(Api.User.currentUserId)
        print("Reference from deletion: \(following)")
        following.removeValue { error, _ in
            print(error?.localizedDescription)
        }
        
        //Removing from MY followers list
        let follower = Ref().databaseFollowingForUser(uid: Api.User.currentUserId).child(user.uid)
        print("Reference from deletion: \(follower)")
        follower.removeValue { error, _ in
            print(error?.localizedDescription)
        }
    }
    
    
    @IBAction func websiteBtnDidTap(_ sender: Any) {
        Api.User.getUserInforSingleEvent(uid: user.uid) { (user) in
            if user.website == nil {
                let alert = UIAlertController(title: "No Website", message: "This artist does not have a link to a site", preferredStyle: .alert)
                
                self.present(alert, animated: true)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                }))
            } else {
                if let url = NSURL(string: user.website!) {
                    UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
                }
            }
        }
    }
    
    
    func observeData() {
        Api.Audio.loadAudioFile(artist: user.uid) { (audio) in
            //creates an array called "audioCollection" which containts all the audio files
            self.audio.append(audio)
            self.sortAudio()
        }
    }
    
    func sortAudio() {
        audio = audio.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "AudioTableViewCell") as! AudioTableViewCell
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
        
        Api.User.getUserInforSingleEvent(uid: cell.audio.artist) { (user) in
            self.popupContentController.artistName = user.username
            self.popupContentController.albumArt = user.profileImage
            //This works
            let url = URL(string: user.profileImageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            self.popupContentController.albumArt = UIImage(data: data!)!
        }
        popupContentController.songTitle = cell.audio.title

        let url = URL(string: user.profileImageUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.popupContentController.albumArt = UIImage(data: data!)!

        //Stopping the audio if it is already playing
        if popupContentController.player != nil {
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
            //tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
            tabBarController?.popupBar.tintColor = UIColor(red: 160, green: 160, blue: 160, alpha: 1)
        }
                
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

