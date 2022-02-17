//
//  AudioTableViewCell.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/14/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Firebase
import FirebaseDatabase

class AudioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!

    var audio: Audio!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //Function called from the table view controller. This places the audio attributes in the proper visual place.
    func configureCell(uid: String, audio: Audio) {
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.black.cgColor
        
        let color = getUIColor(hex: "#1A1A1A")
        self.backgroundColor = color
        self.titleLbl.textColor = UIColor.white
        self.titleLbl.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.genreLbl.textColor = UIColor.white
        self.dataLbl.textColor = UIColor.white
        self.likesLbl.textColor = UIColor.white
        
        
        self.audio = audio
        let titleText = audio.title
        self.titleLbl.lineBreakMode = .byTruncatingTail
        //Title should never be empty... not sure what the purose of this is. Might test for scenarios
        if !titleText.isEmpty {
            titleLbl.isHidden = false
            titleLbl.text = audio.title
        }
        
        self.genreLbl.lineBreakMode = .byTruncatingTail
        //Genre should never be empty... not sure what the purose of this is. Might test for scenarios
        let genreText = audio.genre
        if !genreText.isEmpty {
            genreLbl.isHidden = false
            genreLbl.text = audio.genre
        }
        
        //We'll do test styling in here too
        //Time stamp from how long ago the audio file was uploaded
        let date = Date(timeIntervalSince1970: audio.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dataLbl.text = dateString
        
        //Adding boarders to the top and bottom of the cell only
        //https://www.tutorialspoint.com/how-to-add-a-border-to-the-top-and-bottom-of-an-ios-view
        let thickness: CGFloat = 1.0
        let topBorder = CALayer()
        let bottomBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.frame.size.width, height: thickness)
        topBorder.backgroundColor = UIColor.black.cgColor
        bottomBorder.frame = CGRect(x:0, y: self.contentView.frame.size.height - thickness, width: self.contentView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        contentView.layer.addSublayer(topBorder)
        contentView.layer.addSublayer(bottomBorder)

        
        //This returns the numbers of likes under a particular user
        let ref = Database.database().reference().child("likesCount").child(audio.id)
        ref.observe(.value, with: { (snapshot: DataSnapshot!) in
            print(snapshot.childrenCount)
            
            let likesColor = self.getUIColor(hex: "#66CD5D")
            // We're going to apply the key value UI attributed string to a UI button
            let attributedText = NSMutableAttributedString(string: "Likes: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white])
            
            let attributedSubText = NSMutableAttributedString(string: "\(snapshot.childrenCount)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : likesColor])
            
            attributedText.append(attributedSubText)
            self.likesLbl.attributedText = attributedText
            
            
            //self.likesLbl.text = "Likes: \(snapshot.childrenCount)"
        })
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
