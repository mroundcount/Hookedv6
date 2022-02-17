//
//  ProfileTableViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/7/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension ProfileTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let color = getUIColor(hex: "#1A1A1A")
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20)) //set these values as necessary
        returnedView.backgroundColor = color

        let firstLabel = UILabel(frame: CGRect(x: 8, y: 15, width: tableView.bounds.size.width, height: 25))
        let subLabel = UILabel(frame: CGRect(x: 8, y: -3, width: tableView.bounds.size.width, height: 25))
        if (section == 0) {
            firstLabel.text = "Edit Info"
            
        } else if (section == 1) {
            subLabel.text = "Terms"
        } else if (section == 2) {
            subLabel.text = "Logout"
        } else if (section == 3) {
            subLabel.text = "Delete Account"
        }
        
        firstLabel.tintColor = UIColor.white
        firstLabel.backgroundColor = UIColor.clear
        
        subLabel.tintColor = UIColor.white
        subLabel.backgroundColor = UIColor.clear
        //label.font.UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        firstLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        subLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        returnedView.addSubview(firstLabel)
        returnedView.addSubview(subLabel)

        return returnedView
    }

    func setUpUI() {
        setUpBackground()
        setUpLbl()
        setUpAvatar()
        setUpBackBtn()
        setUpExplicit()
        
        setUpSaveBtn()
    }
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
        self.tableView.backgroundColor = color
    }
    
    func setUpLbl() {
        let color = getUIColor(hex: "#1A1A1A")
        self.titleLbl.text = "Options"
        self.titleLbl.textColor = .white
        self.titleLbl.backgroundColor = color
    }
    
    func setUpBackBtn() {
        backBtn.setImage(UIImage(named: "close-1"), for: .normal)
        backBtn.tintColor = .white
        backBtn.backgroundColor = UIColor.gray
        backBtn.layer.cornerRadius = 15
        backBtn.clipsToBounds = true
    }
    
    func setUpAvatar() {
        avatar.clipsToBounds = true
        //adding actions to respond to tap gesture
        avatar.isUserInteractionEnabled = true
        //use self becauase it it is on the signUpViewController itseld
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            if user.profileImageUrl == "" {
                self.avatar.loadImage("https://firebasestorage.googleapis.com/v0/b/hooked-217d3.appspot.com/o/profile%2FBwfxgQ9mmzNk7jRjO0hzjC9qyBs1?alt=media&token=b5bfe675-8aa8-4ecd-ac20-8ada0b223969")
                
            }
        }
    }
    
    func setUpExplicit() {
        let color = getUIColor(hex: "#66CD5D")
        let backgroundColor = getUIColor(hex: "#1A1A1A")
        self.explicitContentSegment.selectedSegmentTintColor = color
        self.explicitContentSegment.backgroundColor = backgroundColor
        self.explicitContentSegment.layer.borderColor = UIColor.green.cgColor
        self.explicitContentSegment.layer.borderWidth = 2
    }
    
    func setUpSaveBtn() {
        let color = getUIColor(hex: "#66CD5D")
        self.saveBtn.setTitle("Save Updates", for: UIControl.State.normal)
        self.saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.saveBtn.titleLabel?.textColor = UIColor.white
        self.saveBtn.tintColor = UIColor.white
        
        self.saveBtn.backgroundColor = color
        self.saveBtn.layer.cornerRadius = 27.5
        self.saveBtn.clipsToBounds = true
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
