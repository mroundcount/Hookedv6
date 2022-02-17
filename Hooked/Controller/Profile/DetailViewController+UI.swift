//
//  DetailViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/15/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController {
    
    func setUpUI(){
        setUpBackground()
        setUpBackBtn()
        setUpWebsiteBtn()
        setUpUsernameLabel()
        setUpAvatar()
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
        self.tableView.backgroundColor = color
    }
    
    func setUpBackBtn() {
        backBtn.setImage(UIImage(named: "close-1"), for: .normal)
        backBtn.tintColor = .white
        backBtn.backgroundColor = UIColor.gray
        backBtn.layer.cornerRadius = 15
        backBtn.clipsToBounds = true
    }
    
    func setUpWebsiteBtn() {
        websiteBtn.setImage(UIImage(named: "website"), for: .normal)
        websiteBtn.backgroundColor = UIColor.black
        websiteBtn.tintColor = .white
        websiteBtn.layer.cornerRadius = 15
        websiteBtn.clipsToBounds = true
    }
    
    func setUpUsernameLabel() {
        usernameLbl.numberOfLines = 0
        usernameLbl.adjustsFontSizeToFitWidth = true
        usernameLbl.text = "  \(user.username)"
        //Use GUI to add a gradient layer. Pick a custom color and adjust the opacity
    }
    
    func setUpAvatar() {
        //Adding logic for a default profile picture if null
        if user.profileImageUrl != "" {
            self.avatar.loadImage(user.profileImageUrl)
        } else {
            self.avatar.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
        }
        avatar.clipsToBounds = true
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        avatar.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
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
