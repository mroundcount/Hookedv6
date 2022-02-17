//
//  EditUploadTableViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/9/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension EditUploadTableViewController {
    
    
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
        setUpLbl()
        setUpTitle()
        setUpGenre()
        
        enterStartMinTime()
        enterStartSecTime()
        enterStopMinTime()
        enterStopSecTime()
        enterAudioName()
        enterGenre()
        
        setUpRequirementsLbl()
        setUpStartTimeLbl()
        setUpStopTimeLbl()
        
        setUpPreviewBtn()
        setUpSaveBtn()
        
        UITableViewHeaderFooterView.appearance().tintColor = .red
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
        fileNameLbl.isHidden = true
        pageLbl.text = "Edit Song"
        pageLbl.textColor = .white
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
        genreLbl.layer.borderWidth = 2
        genreLbl.layer.borderColor = UIColor.green.cgColor
        genreLbl.layer.cornerRadius = 10
        genreLbl.clipsToBounds = true
        genreLbl.backgroundColor = UIColor.clear
        genreLbl.textColor = UIColor.white
        //Using the UI to add padding to the label
        //https://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel
    }
    
    func setUpPreviewBtn() {
        let color = getUIColor(hex: "#66CD5D")
        self.previewBtn.setTitle("Preview", for: UIControl.State.normal)
        self.previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.previewBtn.titleLabel?.textColor = UIColor.white
        self.previewBtn.tintColor = UIColor.white
        
        self.previewBtn.backgroundColor = color
        self.previewBtn.layer.cornerRadius = 27.5
        self.previewBtn.clipsToBounds = true
    }
    
    func setUpSaveBtn() {
        let color = getUIColor(hex: "#66CD5D")
        self.saveBtn.setTitle("Save Changes", for: UIControl.State.normal)
        self.saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.saveBtn.titleLabel?.textColor = UIColor.white
        self.saveBtn.tintColor = UIColor.white
        
        self.saveBtn.backgroundColor = color
        self.saveBtn.layer.cornerRadius = 27.5
        self.saveBtn.clipsToBounds = true
    }
    
    
    
    
    func enterAudioName() {
        let placeholderAttr = NSAttributedString(string: "\(audio.title)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        //titleTextField.attributedPlaceholder = placeholderAttr
        titleTextField.text = audio.title
        titleTextField.textColor = UIColor.white
    }
    
    func enterGenre() {
        genreLbl.text = "\(audio.genre)"
        genreLbl.textColor = UIColor.white
    }
    
    func enterStartMinTime() {
        let color = getUIColor(hex: "#66CD5D")
        let startMin : Int = Int(audio.startTime/60)
        print("start min: \(startMin)")
        
        let placeholderAttr = NSAttributedString(string: "\(startMin)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        //startTimeMinTextField.attributedPlaceholder = placeholderAttr
        startTimeMinTextField.text = String(startMin)
        startTimeMinTextField.textColor = UIColor.white
        startTimeMinTextField.layer.borderColor = UIColor.green.cgColor
        startTimeMinTextField.layer.borderWidth = 1
        startTimeMinTextField.layer.cornerRadius = 5
        startTimeMinTextField.clipsToBounds = true
        
    }
    
    func enterStartSecTime() {
        let color = getUIColor(hex: "#66CD5D")

        let startMin : Int = Int(audio.startTime/60)
        let startSec : Int = Int(audio.startTime - Double(startMin*60))
        print("start sec: \(startSec)")
        
        let placeholderAttr = NSAttributedString(string: "\(startSec)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        //startTimeSecTextField.attributedPlaceholder = placeholderAttr
        startTimeSecTextField.text = String(startSec)
        startTimeSecTextField.textColor = UIColor.white
        startTimeSecTextField.layer.borderColor = UIColor.green.cgColor
        startTimeSecTextField.layer.borderWidth = 1
        startTimeSecTextField.layer.cornerRadius = 5
        startTimeSecTextField.clipsToBounds = true
    }
    
    func enterStopMinTime() {
        let stoptMin : Int = Int(audio.stopTime/60)
        print("start min: \(stoptMin)")
        
        let placeholderAttr = NSAttributedString(string: "\(stoptMin)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        //stopTimeMinTextField.attributedPlaceholder = placeholderAttr
        stopTimeMinTextField.text = String(stoptMin)
        stopTimeMinTextField.textColor = UIColor.white
        stopTimeMinTextField.layer.borderColor = UIColor.green.cgColor
        stopTimeMinTextField.layer.borderWidth = 1
        stopTimeMinTextField.layer.cornerRadius = 5
        stopTimeMinTextField.clipsToBounds = true
    }
    
    func enterStopSecTime() {
        let stopMin : Int = Int(audio.stopTime/60)
        let stopSec : Int = Int(audio.stopTime - Double(stopMin*60))
        print("start sec: \(stopSec)")
        
        let placeholderAttr = NSAttributedString(string: "\(stopSec)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        //stopTimeSecTextField.attributedPlaceholder = placeholderAttr
        stopTimeSecTextField.text = String(stopSec)
        stopTimeSecTextField.textColor = UIColor.white
        stopTimeSecTextField.layer.borderColor = UIColor.green.cgColor
        stopTimeSecTextField.layer.borderWidth = 1
        stopTimeSecTextField.layer.cornerRadius = 5
        stopTimeSecTextField.clipsToBounds = true
    }
    
    func setUpRequirementsLbl() {
        timeRequirementsLbl.text = "Enter the start time and end time (seconds) for your song. Length must not be longer than 15 seconds \nExample: 1 minute 15 seconds"
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


