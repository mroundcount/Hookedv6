//
//  AudioReportViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/19/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD

extension AudioReportViewController {
    
    func setUpUI() {
       // setupNavigationBar()
        //setUpBackground()
        setUpTitle()
        setUpBackBtn()
        setUpLabels()
        setUpCommentField()
        setUpSubmitBtn() 
        //Hiding these fields for now... they don't have use right now.
        //userEmailLbl.isHidden = true
        //updateEmailTxt.isHidden = true
        //policyLbl.isHidden = true
    }
    
    func setupNavigationBar() {
        //navigationItem.title = "File a report"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        let back = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = back
        back.tintColor = UIColor.white

    }
    
    func setUpBackground(){
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
    }
    
    func setUpBackBtn() {
        self.backBtn.setImage(UIImage(named: "close-1"), for: .normal)
        self.backBtn.tintColor = .white
        self.backBtn.backgroundColor = UIColor.gray
        self.backBtn.layer.cornerRadius = 15
        self.backBtn.clipsToBounds = true
    }
    
    func setUpTitle() {
        self.titleLbl.text = "File a Report"
        self.titleLbl.textColor = UIColor.white
    }
    

    func setUpLabels() {
        let color = getUIColor(hex: "#66CD5D")
        
        self.complaintLbl.text = "You are filing a report against:"
        self.complaintLbl.textColor = UIColor.white
        
        Api.User.getUserInforSingleEvent(uid: audio.artist) { (user) in
            let attributedSongText = NSMutableAttributedString(string: "Song: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white])
            let attributedSongSubTitle = NSMutableAttributedString(string: "\(self.audio.title)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : color])
            //The combination of the two attributed texts
            attributedSongText.append(attributedSongSubTitle)
            self.audioTitleLbl.attributedText = attributedSongText
            self.audioTitleLbl.numberOfLines = 0
            
            //File complaint against song:
            let attributedArtistText = NSMutableAttributedString(string: "By: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white])
            let attributedArtistSubTitle = NSMutableAttributedString(string: "\(user.username)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : color])
            //The combination of the two attributed texts
            attributedArtistText.append(attributedArtistSubTitle)
            self.artistLbl.attributedText = attributedArtistText
            self.artistLbl.numberOfLines = 0
        }
        
        //We're not using this right now.... maybe use it later?
        /*
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.userEmailLbl.text = "We have your email address as: '\(user.email)' if that is not the best way to contact you add an email address below: "
        }
        self.updateEmailTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.updateEmailTxt.layer.borderWidth = 1
        self.policyLbl.text = "We reviee each report. We will contact you at the email address provided"
        */
        
        self.reasonLbl.text = "Select a reasons for reporting this song:"
        self.reasonLbl.textColor = UIColor.white
        
    }
    
    func setUpCommentField() {
        self.commentLbl.text = "Please add additional details:"
        self.commentField.layer.borderColor = UIColor.white.cgColor
        self.commentField.layer.borderWidth = 2
        self.commentField.layer.cornerRadius = 10
        self.commentField.backgroundColor = UIColor.clear
        self.commentField.clipsToBounds = true
    }
    
    func setUpSubmitBtn() {
        let color = getUIColor(hex: "#66CD5D")
        submitBtn.setTitle("Submit", for: UIControl.State.normal)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        submitBtn.titleLabel?.textColor = UIColor.white
        submitBtn.backgroundColor = color
        submitBtn.layer.cornerRadius = 27.5
        submitBtn.clipsToBounds = true
        
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
