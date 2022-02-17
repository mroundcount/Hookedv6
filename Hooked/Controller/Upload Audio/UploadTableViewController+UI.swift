//
//  UploadTableViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/4/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension UploadTableViewController {
    
    //Setting up the head color selection
    //https://stackoverflow.com/questions/813068/uitableview-change-section-header-color
    //https://www.codegrepper.com/code-examples/swift/change+background+color+of+uitableview+section+header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let color = getUIColor(hex: "#1A1A1A")
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20)) //set these values as necessary
        returnedView.backgroundColor = color

        let label = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 15))
        if (section == 1) {
            label.text = "GENRE"
        } else if (section == 2) {
            label.text = "EXPLICIT CONTENT"
        } else if (section == 3) {
            label.text = "PREVIEW TIME"
        }
        label.tintColor = UIColor.white
        //label.font.UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        returnedView.addSubview(label)
        
        return returnedView
    }
    

    
    func setUpUI(){
        setUpBackground()
        setUpBackBtn()
        setUpBrowseBtn()
        setUpLbl()
        setUpTitle()
        setUpGenre()
        
        enterStartMinTime()
        enterStartSecTime()
        enterStopMinTime()
        enterStopSecTime()
        
        setUpRequirementsLbl()
        setUpStartTimeLbl()
        setUpStopTimeLbl()
        
        setUpSaveBtn()
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
        self.tableView.backgroundColor = color
        self.lblBackground.backgroundColor = color
    }
    
    func setUpBackBtn() {
        backBtn.setImage(UIImage(named: "close-1"), for: .normal)
        backBtn.tintColor = .white
        backBtn.backgroundColor = UIColor.gray
        backBtn.layer.cornerRadius = 15
        backBtn.clipsToBounds = true
    }
    
    func setUpLbl() {
        pageLbl.text = "Upload Songs"
        pageLbl.textColor = .white
    }
    
    func setUpBrowseBtn() {
        let color = getUIColor(hex: "#66CD5D")
        browseBtn.setTitle("Browse Files", for: UIControl.State.normal)
        browseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        browseBtn.titleLabel?.textColor = UIColor.white
        browseBtn.tintColor = UIColor.white
        browseBtn.backgroundColor = color
        browseBtn.layer.cornerRadius = 25
        browseBtn.clipsToBounds = true
        /*
        browseBtn.setTitleColor(color, for: .normal)
        browseBtn.backgroundColor = UIColor.clear
        browseBtn.layer.borderWidth = 2
        browseBtn.layer.borderColor = UIColor.green.cgColor
        browseBtn.layer.cornerRadius = 25
        browseBtn.clipsToBounds = true
        */
    }
    
    func setUpSaveBtn() {
        let color = getUIColor(hex: "#66CD5D")
        saveBtn.setTitle("Submit", for: UIControl.State.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        saveBtn.titleLabel?.textColor = UIColor.white
        saveBtn.tintColor = UIColor.white
        saveBtn.backgroundColor = color
        saveBtn.layer.cornerRadius = 27.5
        saveBtn.clipsToBounds = true
    }
    
    func setUpTitle() {
        let color = getUIColor(hex: "#66CD5D")
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.borderColor = UIColor.green.cgColor
        titleTextField.layer.cornerRadius = 10
        titleTextField.clipsToBounds = true
        titleTextField.backgroundColor = UIColor.clear
        titleTextField.borderStyle = .none
        titleTextField.textColor = UIColor.white        
        titleTextField.setLeftPaddingPoints(10)
        
        titleTextField.attributedPlaceholder =
        NSAttributedString(string: "Song Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func setUpGenre() {
        let color = getUIColor(hex: "#66CD5D")
        genreLbl.isHidden = true
        
        explicitSegment.selectedSegmentTintColor = color
        explicitSegment.layer.borderColor = UIColor.green.cgColor
        explicitSegment.layer.borderWidth = 2
    }
    
    func enterStartMinTime() {
        let color = getUIColor(hex: "#66CD5D")
        let placeholderAttr = NSAttributedString(string: "Min [00]", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        startTimeMinTextField.attributedPlaceholder = placeholderAttr
        startTimeMinTextField.textColor = UIColor.white
        startTimeMinTextField.layer.borderColor = UIColor.green.cgColor
        startTimeMinTextField.layer.borderWidth = 1
        startTimeMinTextField.layer.cornerRadius = 5
        startTimeMinTextField.clipsToBounds = true
    }
    
    func enterStartSecTime() {
        let color = getUIColor(hex: "#66CD5D")
        let placeholderAttr = NSAttributedString(string: "Sec [00]", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        startTimeSecTextField.attributedPlaceholder = placeholderAttr
        startTimeSecTextField.textColor = UIColor.white
        startTimeSecTextField.layer.borderColor = UIColor.green.cgColor
        startTimeSecTextField.layer.borderWidth = 1
        startTimeSecTextField.layer.cornerRadius = 5
        startTimeSecTextField.clipsToBounds = true
        
        
    }
    
    func enterStopMinTime() {
        let color = getUIColor(hex: "#66CD5D")
        let placeholderAttr = NSAttributedString(string: "Min [00]", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        stopTimeMinTextField.attributedPlaceholder = placeholderAttr
        stopTimeMinTextField.textColor = UIColor.white
        stopTimeMinTextField.layer.borderColor = UIColor.green.cgColor
        stopTimeMinTextField.layer.borderWidth = 1
        stopTimeMinTextField.layer.cornerRadius = 5
        stopTimeMinTextField.clipsToBounds = true
    }
    
    func enterStopSecTime() {
        let color = getUIColor(hex: "#66CD5D")
        let placeholderAttr = NSAttributedString(string: "Sec [00]", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        stopTimeSecTextField.attributedPlaceholder = placeholderAttr
        stopTimeSecTextField.textColor = UIColor.white
        stopTimeSecTextField.layer.borderColor = UIColor.green.cgColor
        stopTimeSecTextField.layer.borderWidth = 1
        stopTimeSecTextField.layer.cornerRadius = 5
        stopTimeSecTextField.clipsToBounds = true
    }
    
    func setUpRequirementsLbl() {
        timeRequirementsLbl.text = "Enter the start time and end time [MIN:SEC] for your song. Length must not be longer than 15 seconds. \nExample: 1 minute 15 seconds"
        timeRequirementsLbl.textColor = UIColor.white
        
    }
    
    func setUpStartTimeLbl() {
        startTimeLbl.text = "Starting Time: "
        startTimeLbl.textColor = UIColor.white
    }
    
    func setUpStopTimeLbl() {
        stopTimeLbl.text = "Stopping Time: "
        stopTimeLbl.textColor = UIColor.white
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

//https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

