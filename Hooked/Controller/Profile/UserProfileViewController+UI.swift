//
//  UserProfileViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/18/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension UserProfileViewController {
    func setUpUI(){
        setUpBackground()
        setUpNavigationBtns()
        setUpUsernameLabel()
        setUpProfilePicture()
        observeProfileData()
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
        self.tableView.backgroundColor = color
    }
    
    func setUpNavigationBtns() {
        let color = getUIColor(hex: "#66CD5D")
        uploadBtn.layer.cornerRadius = 20
        uploadBtn.clipsToBounds = true
        uploadBtn.backgroundColor = color
    
        optionsBtn.layer.cornerRadius = 20
        optionsBtn.clipsToBounds = true
        optionsBtn.backgroundColor = color
    }
    
    func setUpUsernameLabel() {
        usernameLbl.numberOfLines = 0
        usernameLbl.adjustsFontSizeToFitWidth = true
        //Use GUI to add a gradient layer. Pick a custom color and adjust the opacity
    }
    //Experiment with these

    func setUpProfilePicture() {
    avatar.clipsToBounds = true
    let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
    avatar.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
    }
    
    func observeProfileData() {
        //fetching current user data
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameLbl.text = "  \(user.username)"
            
            //Testing to see if we can use a blank profile pic
            if user.profileImageUrl != "" {
                self.avatar.loadImage(user.profileImageUrl)
            } else {
                self.avatar.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
            }
            
            print("Observe complete")
        }
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

