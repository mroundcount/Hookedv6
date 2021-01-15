//
//  NewMatchTableViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 7/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import LNPopupController
import AVFoundation
import FirebaseDatabase

class LikesTableViewController: UITableViewController, UISearchResultsUpdating, ProfileNavigationDelegate {
    
    var audio: [Audio] = []
    var searchResults: [Audio] = []
    var audioSet: Audio!
    
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var audioPlayer: AVAudioPlayer!
    var popupContentController: DemoMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupSearchBarController()
        
        popupContentController = storyboard?.instantiateViewController(withIdentifier: "DemoMusicPlayerController") as! DemoMusicPlayerController
        
        AVAudioSession.sharedInstance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("In new likes view")
        observeAudio()
    }
    
   //This is a temporary measure until I cn figure out how to only stop this player when the discover view controller is up.
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if popupContentController.audioPlayer != nil {
            print("audio is playing")
            popupContentController.closeAction()
        } else {
            print("AudioPlayer is null")
            return
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Liked Songs"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchBarController() {
        //front end characterists of the searchbar
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search playlist..."
        searchController.searchBar.barTintColor = UIColor.white
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
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
        searchResults = self.audio.filter {
            return $0.title.lowercased().range(of: searchText) != nil
        }
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func observeAudio() {
        self.audio.removeAll()
        print("inside observation function")
        Api.Audio.observeNewLike { (audio) in
            self.audio.append(audio)
            self.tableView.reloadData()
            self.sortAudio()
        }
    }
    
    func sortAudio() {
        audio = audio.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    //Added for navigation
    func didTapProfilePicture(audio: Audio!) {
        print ("Make it here")
        print("from the viewcontroller: \(audio.artist)")
        
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            print("user: \(user.username)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            detailVC.user = user
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return self.audio.count
        }
        //return searchController.isActive ? searchResults.count : self.users.count
        //return searchController.isActive ? searchResults.count : self.audio.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "AudioTableViewCell") as! AudioTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesAudioTableViewCell", for: indexPath) as! LikesAudioTableViewCell
        
        //cell.configureCell(audio: audio[indexPath.row])
        
        let search = searchController.isActive ? searchResults[indexPath.row] :
            audio[indexPath.row]
        cell.configureCell(audio: search)
        
        cell.profileNavigationDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LikesAudioTableViewCell
        
        popupContentController.songTitle = cell.audio.title
        
        Api.User.getUserInforSingleEvent(uid: cell.audio.artist) { (user) in
            self.popupContentController.artistName = user.username

            //Sets the default picture if the profile picture is null
            if user.profileImageUrl != "" {
                let url = URL(string: user.profileImageUrl)
                let data = try? Data(contentsOf: url!)
                self.popupContentController.albumArt = UIImage(data: data!)!
            } else {
                self.popupContentController.albumArt = UIImage(named: "default_profile")!
            }
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
    
    //Removing the liked audio from the table
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //copy this and add the variables in the return with "delete
        let delete = UITableViewRowAction(style: .normal, title: "      Delete     ") { action, index in
            let cell = tableView.cellForRow(at: editActionsForRowAt) as? LikesAudioTableViewCell
            print("Removing \(cell?.audio.id) which is titled \(cell?.audio.title)")
            
            //Testing if this works.
            let selection = cell?.audio.id
            let reference = Ref().databaseLikesForUser(uid: Api.User.currentUserId).child(selection!)
            
            //let reference = Database.database().reference().child("likes").child(selection!)
            print("Reference from deletion: \(reference)")
            //Test making the error optional
            reference.removeValue { error, _ in
                print(error?.localizedDescription)
            }
            //The table reload does not work for some reason
            //self.tableView.reloadData()
            self.viewDidAppear(true)
        }
        delete.backgroundColor = .red
        
        return [delete]
        
        
    }
}

//we can not use the same cell class as "people"
//I don't remember what this is
extension LikesTableViewController: UpdateTableProtocol {
    func reloadData() {
        self.tableView.reloadData()
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

