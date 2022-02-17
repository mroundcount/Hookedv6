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
        
        setUpCell()
    }
    
    func setUpCell() {
        let color = getUIColor(hex: "#1A1A1A")
        self.backgroundColor = color
        self.titleLbl.textColor = UIColor.white
        self.artistLbl.textColor = UIColor.white
    }

    
    //Function called from the table view controller
    func configureCell(audio: Audio) {
        self.audio = audio
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            self.artistLbl.text = user.username
            
            //Defaulting to a blank profile pic
            if user.profileImageUrl != "" {
                self.avatar.loadImage(user.profileImageUrl)
            } else {
                self.avatar.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
            }
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
    
    //Function for converting HEX to RGBA
    //https://www.zerotoappstore.com/how-to-set-custom-colors-swift.html
    func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }
        if ((cleanString.count) != 6) {
            return nil
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
