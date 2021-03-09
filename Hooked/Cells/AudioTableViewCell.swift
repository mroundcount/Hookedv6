//
//  AudioTableViewCell.swift
//  Hooked
//
//  Created by Michael Roundcount on 5/14/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import AVFoundation

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

        
        //This returns the numbers of likes under a particular user
        let ref = Database.database().reference().child("likesCount").child(audio.id)
        ref.observe(.value, with: { (snapshot: DataSnapshot!) in
            print("Got snapshot")
            print(audio.id)
            print(snapshot.childrenCount)
            print("Count of \(audio.title): \(audio.id) : \(snapshot.childrenCount)")
            self.likesLbl.text = "Likes: \(snapshot.childrenCount)"
        })

    }
    
    //This is commented out everywhere.... review it later.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
