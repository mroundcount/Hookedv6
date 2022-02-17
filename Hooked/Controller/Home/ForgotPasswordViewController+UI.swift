//
//  ForgotPasswordViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/29/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit

extension ForgotPasswordViewController {
    
    func setUpCloseBtn() {
        print("here")
        self.closeBtn.backgroundColor = UIColor.gray
        self.closeBtn.layer.cornerRadius = 15
    }
    
    func setUpBackground() {
        self.view.backgroundColor = UIColor.black
    }
    
    func setUpTitleTextLbl() {
        let color = getUIColor(hex: "#66CD5D")
        let titleText = "Reset Password"
        //copy over from ViewController+UI
        let attributedText = NSMutableAttributedString(string: titleText, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Arial Hebrew", size: 35)!, NSAttributedString.Key.foregroundColor : color])
        self.titleText.attributedText = attributedText
        self.titleText.textAlignment = .center
    }

    func setUpEmailTxt() {
    //copy over from SignUpViewController+UI
        let color = getUIColor(hex: "#66CD5D")
        self.emailContainerView.layer.borderWidth = 2
        self.emailContainerView.layer.borderColor = UIColor.green.cgColor
        self.emailContainerView.layer.cornerRadius = 27.5
        self.emailContainerView.clipsToBounds = true
        self.emailContainerView.backgroundColor = UIColor.clear
        self.emailTxt.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.emailTxt.attributedPlaceholder = placeholderAttr
        self.emailTxt.textColor = color
    }
    func setUpResetBtn() {
        let color = getUIColor(hex: "#66CD5D")
        resetBtn.setTitle("Reset My Password", for: UIControl.State.normal)
        resetBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        resetBtn.backgroundColor = UIColor.white
        resetBtn.layer.cornerRadius = 27.5
        resetBtn.clipsToBounds = true
        resetBtn.setTitleColor(.white, for: UIControl.State.normal)
        resetBtn.backgroundColor = color
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
    
    //Dismissing the keyboard. Looks for the repsonder to the text field to give up the startis
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
