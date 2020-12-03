//
//  LikesAudioTableViewCell.swift
//  Hooked
//
//  Created by Michael Roundcount on 7/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

protocol UpdateTableProtocol {
    func reloadData()
}

protocol ProfileNavigationDelegate {
    func didTapProfilePicture(audio: Audio!)
}


//This is the card layout for audio in the liked view controller
class LikesAudioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBOutlet weak var profileNavigateBtn: UIButton!
    
    //Added for navigation
    var id: String?
    var profileNavigationDelegate : ProfileNavigationDelegate?
    //End
    
    var audio: Audio!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        //making the avatar circular
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        avatar.contentMode = . scaleAspectFill
        
        //Allowing the avatar to be selected for navigation purposes.
        avatar?.isUserInteractionEnabled = true
        //let tapGesture = UITapGestureRecognizer (target: self, action: #selector(self.profilePictureTap))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureTap(sender:)))
        avatar?.addGestureRecognizer(tapGesture)
    }

    
    //Function called from the table view controller
    func configureCell(audio: Audio) {
        self.audio = audio
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            self.artistLbl.text = user.username
            self.avatar.loadImage(user.profileImageUrl)
        }
        self.titleLbl.text = audio.title
        //titleLbl.adjustsFontSizeToFitWidth = true
        self.titleLbl.lineBreakMode = .byTruncatingTail

    }
    
    //Actual method to navigate to the selected user's profile.
    @objc func profilePictureTap(sender: UITapGestureRecognizer) {
        print("Picture Tapped")
        print("artist: \(audio.artist)")
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            print("user: \(user.username)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            detailVC.user = user
        }
        self.profileNavigationDelegate?.didTapProfilePicture(audio: self.audio)
    }

    //This is commented out everywhere.... review it later.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
