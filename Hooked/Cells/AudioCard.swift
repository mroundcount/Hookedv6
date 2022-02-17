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
    
    
    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var nopeView: UIView!
    @IBOutlet weak var nopeLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    
    private var gradient: CAGradientLayer!
    
    var controller: AudioRadarViewController!
    var AudioFile: [Audio] = []
    
    var audioPlayer: AVAudioPlayer!
    var audioPath: URL!
    
    
    
    //for testing
    var user: User!
    
    var block: Bool = false
    
    //My modifications to it.
    var audio: Audio! {
        //pass the user object the array and create a new card, then append the card to the cards array
        didSet {
            Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
                
                //self.photo.loadImage(user.profileImageUrl)
                //Testing to see if we can use a blank profile pic
                if user.profileImageUrl != "" {
                    self.photo.loadImage(user.profileImageUrl)
                } else {
                    self.photo.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
                }

                //Customizing the text for the username label
                let attributedArtistText = NSMutableAttributedString(string: "   \(user.username)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.white])
                self.usernameLbl.attributedText = attributedArtistText
                
                self.usernameLbl.numberOfLines = 1
                self.usernameLbl.lineBreakMode = .byTruncatingTail
                self.usernameLbl.adjustsFontSizeToFitWidth = false
            }
            //Customizing the text for the audio title label
            let attributedTitleText = NSMutableAttributedString(string: "  \(audio.title)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor : UIColor.white])
            self.titleLbl.attributedText = attributedTitleText
            self.titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
            self.titleLbl.numberOfLines = 1
            self.titleLbl.lineBreakMode = .byTruncatingTail
            self.titleLbl.adjustsFontSizeToFitWidth = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Blurring effect on the title and artist.
        //https://stackoverflow.com/questions/25529500/how-to-set-the-blurradius-of-uiblureffectstyle-light
        //https://www.raywenderlich.com/16125723-uivisualeffectview-tutorial-getting-started#toc-anchor-001
        textBackgroundView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.75
        blurView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: textBackgroundView.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: textBackgroundView.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: textBackgroundView.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: textBackgroundView.widthAnchor)
        ])
        
        let color = getUIColor(hex: "#1A1A1A")
        //adding gradient to the avatar
        //backgroundColor = .clear
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        //rounding the corners
        photo.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        backgroundColor = color


        gradient = CAGradientLayer()
        gradient.frame = photo.bounds
 
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        
        textBackgroundView.layer.cornerRadius = 10
        textBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] // Top right corner, Top left corner respectively
        textBackgroundView.clipsToBounds = true
        
        
        
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
    
    @IBAction func infoBtnDidTap(_ sender: UIButton) {
        print("Button tapped")
        
        var alert = UIAlertController(title: "Flagging Options",message:"Choose below: ",
                                      preferredStyle: UIAlertController.Style.alert)
            
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Report", style: UIAlertAction.Style.default, handler: { action in
            
            print ("Make it here")
            print("from the viewcontroller: \(self.audio.artist)")
           /*
            Api.User.getUserInforSingleEvent(uid: self.audio.artist) { (user) in
                print("user: \(user.username)")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let reportVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_AUDIO_REPORT) as! AudioReportViewController
                reportVC.user = user
                
                //self.presentViewController(reportVC, animated: true, completion: nil)
                (self.superview?.next as? UIViewController)?.navigationController?.pushViewController(reportVC, animated: false)

            }
            */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let reportVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_AUDIO_REPORT) as! AudioReportViewController
            reportVC.audio = self.audio

            
            self.controller.navigationController?.pushViewController(reportVC, animated: true)
             
            

            
        }))
        
        //Beginning of blocking options
        alert.addAction(UIAlertAction(title: "Block User", style: UIAlertAction.Style.default, handler: { action in
            //First layer of alerts
            let alert = UIAlertController(title: "Are you sure?", message: "You are about to block all content from this artist forever", preferredStyle: .alert)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            //Once there is confirmation
            alert.addAction(UIAlertAction(title: "Yes, Block This Artist", style: .default, handler: { action in
                print("You clicked yes")
                self.saveBlocksToFirebase()
            }))
            //End Confirmation
        }))
        //End blocking options
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))

        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func saveBlocksToFirebase() {
        self.block = true
        print("Blocking user: \(self.audio.artist)")
        Ref().databaseBlockUserForUser(uid: Api.User.currentUserId)
            .updateChildValues([self.audio.artist: block]) { (error, ref) in
                if error == nil, self.block == true {
                }
            }
        let alert = UIAlertController(title: "", message: "This artist is blocked from your feed once you refresh this page. Continue swiping", preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    
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
