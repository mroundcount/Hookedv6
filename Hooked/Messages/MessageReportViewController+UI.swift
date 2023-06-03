//
//  MessageReportViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/30/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import UIKit
import ProgressHUD

extension MessageReportViewController {
    
    func setUpUI() {
        //setupNavigationBar()
        setUpTitle()
        setUpBackBtn()
        setUpLabels()
        setUpCommentField()
        setUpSubmitBtn()
    }
        
    func setupNavigationBar() {
        //navigationItem.title = "File a report"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        let back = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = back
        back.tintColor = UIColor.white
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

        Api.User.getUserInforSingleEvent(uid: message.from) { (user) in
            //File complaint against song:
            let attributedArtistText = NSMutableAttributedString(string: "You are filing a report against: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white])
            let attributedArtistSubTitle = NSMutableAttributedString(string: "\(user.username)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : color])
            //The combination of the two attributed texts
            attributedArtistText.append(attributedArtistSubTitle)
            self.artistLbl.attributedText = attributedArtistText
            self.artistLbl.numberOfLines = 0
        }
        
        self.reasonLbl.text = "Select a reasons for reporting this message:"
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
