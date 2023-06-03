//
//  MessageTableViewCell.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/24/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import UIKit

protocol MessageProfileNavigationDelegate {
    func didTapProfilePicture(message: Message!)
}

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var textMessageLbl: UILabel!
    
    @IBOutlet weak var bubbleViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleViewRightConstraint: NSLayoutConstraint!
    
    var message: Message!
    
    var MessageProfileNavigationDelegate : MessageProfileNavigationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        bubbleView.layer.cornerRadius = 15
        bubbleView.clipsToBounds = true
        bubbleView.layer.borderWidth = 0.4
        bubbleView.backgroundColor = UIColor.white
        
        textMessageLbl.numberOfLines = 0
        textMessageLbl.backgroundColor = UIColor.white
        textMessageLbl.textColor = UIColor.black
        
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        profileImage.contentMode = . scaleAspectFill
        
        profileImage.isHidden = true
        textMessageLbl.isHidden = true
        
        //Allowing the avatar to be selected for navigation purposes.
        profileImage?.isUserInteractionEnabled = true
        //let tapGesture = UITapGestureRecognizer (target: self, action: #selector(self.profilePictureTap))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureTap(sender:)))
        profileImage?.addGestureRecognizer(tapGesture)
    }

    //Using this to hide the profile picture when you are reviewing your messages
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.isHidden = true
        textMessageLbl.isHidden = true
    }
        
    func configureCell(uid: String, message: Message) {
        self.message = message
        let text = message.text
        if !text.isEmpty {
            textMessageLbl.isHidden = false
            textMessageLbl.text = message.text
            
            let widthValue = text.estimateFrameForText(text).width + 50
            
            if widthValue < 100 {
                bubbleViewWidthConstraint.constant = 100
            } else {
                bubbleViewWidthConstraint.constant = widthValue
            }
            dateLbl.textColor = .black
            usernameLbl.textColor = .black

        } else {
            bubbleView.layer.borderColor = UIColor.clear.cgColor
            bubbleViewWidthConstraint.constant = 250
            dateLbl.textColor = .black
            usernameLbl.textColor = .black
        }
        
        if uid == message.from {
            bubbleView.backgroundColor = UIColor.white
            bubbleView.layer.borderColor = UIColor.clear.cgColor
            bubbleViewRightConstraint.constant = 8
            bubbleViewLeftConstraint.constant = UIScreen.main.bounds.width - bubbleViewWidthConstraint.constant - bubbleViewRightConstraint.constant
        } else {
            profileImage.isHidden = false
            bubbleView.backgroundColor = UIColor.white
            
            //We'll have to replace this with a look up, origional code not intended for this.
            Api.User.getUserInforSingleEvent(uid: message.from) { (user) in
                //self.photo.loadImage(user.profileImageUrl)
                //Testing to see if we can use a blank profile pic
                if user.profileImageUrl != "" {
                    self.profileImage.loadImage(user.profileImageUrl)
                } else {
                    self.profileImage.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
                }
                self.usernameLbl.text = user.username
                
            }
            
            //profileImage.image = message.from
            bubbleView.layer.borderColor = UIColor.lightGray.cgColor
            bubbleViewLeftConstraint.constant = 75
            bubbleViewRightConstraint.constant = UIScreen.main.bounds.width - bubbleViewWidthConstraint.constant - bubbleViewLeftConstraint.constant
        }
        
        let date = Date(timeIntervalSince1970: message.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLbl.text = dateString
    }
    
    //Actual method to navigate to the selected user's profile.
    @objc func profilePictureTap(sender: UITapGestureRecognizer) {
        print("artist: \(message.from)")
        Api.User.getUserInforSingleEvent(uid: message.from) { (user) in
            print("user: \(user.username)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            detailVC.user = user
        }
        self.MessageProfileNavigationDelegate?.didTapProfilePicture(message: self.message)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
