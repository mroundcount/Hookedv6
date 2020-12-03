//
//  AudioCard.swift
//  Hooked
//
//  Created by Michael Roundcount on 6/30/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit

//From an older version... not sure if I need CoreLocation
import CoreLocation

class AudioCard: UIView {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var nopeView: UIView!
    @IBOutlet weak var nopeLbl: UILabel!
    
    private var gradient: CAGradientLayer!
    
    var controller: AudioRadarViewController!
    var AudioFile: [Audio] = []
    
    var audioPlayer: AVAudioPlayer!
    var audioPath: URL!
    
    //My modifications to it.
    var audio: Audio! {
        //pass the user object the array and create a new card, then append the card to the cards array
        didSet {
            Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
                self.photo.loadImage(user.profileImageUrl)
                //Customizing the text for the username label
                let attributedArtistText = NSMutableAttributedString(string: "   \(user.username)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor : UIColor.white])
                self.usernameLbl.attributedText = attributedArtistText
                
                self.usernameLbl.numberOfLines = 1
                self.usernameLbl.lineBreakMode = .byTruncatingTail
                self.usernameLbl.adjustsFontSizeToFitWidth = false
            }
            //Customizing the text for the audio title label
            let attributedTitleText = NSMutableAttributedString(string: "  \(audio.title)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : UIColor.white])
            self.titleLbl.attributedText = attributedTitleText
            
            self.titleLbl.numberOfLines = 1
            self.titleLbl.lineBreakMode = .byTruncatingTail
            self.titleLbl.adjustsFontSizeToFitWidth = false
            
        }
    }
    
    //I don't think much needs to me modified here.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //adding gradient to the avatar
        //backgroundColor = .clear
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        //rounding the corners
        photo.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        

        gradient = CAGradientLayer()
        gradient.frame = photo.bounds
        
        
        //This looks okay use as a base and move from here
        /*
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.5, 0]
        //gradient.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor, UIColor.black.cgColor]
        //gradient.locations = [0.5, 0.3, 0.1]
        photo.layer.addSublayer(gradient)
        */
 
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
        //styling the like and nope icons
        likeView.alpha = 0
        nopeView.alpha = 0
        
        likeView.layer.borderWidth = 3
        likeView.layer.cornerRadius = 5
        likeView.clipsToBounds = true
        likeView.layer.borderColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1).cgColor
        
        nopeView.layer.borderWidth = 3
        nopeView.layer.cornerRadius = 5
        nopeView.clipsToBounds = true
        nopeView.layer.borderColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1).cgColor
        
        //rotating the cards as we move them from side to side
        likeView.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        nopeView.transform = CGAffineTransform(rotationAngle: .pi / 8)
        
        //added in extension
        nopeLbl.addCharacterSpacing()
        nopeLbl.attributedText = NSAttributedString(string: "NOPE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
        
        nopeView.layer.borderColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1).cgColor
        nopeLbl.textColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1)
        
        //added in extension
        likeLbl.addCharacterSpacing()
        likeLbl.attributedText = NSAttributedString(string: "LIKE",attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
        likeView.layer.borderColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1).cgColor
        likeLbl.textColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1)
        
        titleLbl.sizeToFit()
        usernameLbl.sizeToFit()
    }

}
