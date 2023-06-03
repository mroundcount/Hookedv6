//
//  MessageViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 10/16/22.
//  Copyright © 2022 Michael Roundcount. All rights reserved.
//

import UIKit
import FirebaseAuth
import MobileCoreServices
import AVFoundation

extension MessageViewController {
    
    func setupUI() {
        setUpSegment()
        setupInputTextView()
        setupTableView()
        setupTextBackgroundView()
        
        //Setting up the keyboard tap and dismiss so it does not interfier with other functions like the row selection.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.backgroundColor = UIColor.clear
    }
    
    func setupNativationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTextBackgroundView() {
        let backgroundColor = getUIColor(hex: "#1A1A1A")
        self.textBackgroundView.backgroundColor = backgroundColor
        sendBtn.setTitleColor(.black, for: UIControl.State.normal)
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
    }
 
    func setUpSegment() {
        let color = getUIColor(hex: "#66CD5D")
        let backgroundColor = getUIColor(hex: "#1A1A1A")
        
        self.messageTypeSegmentedControl.selectedSegmentTintColor = color
        self.messageTypeSegmentedControl.backgroundColor = backgroundColor
        self.messageTypeSegmentedControl.layer.borderColor = UIColor.green.cgColor
        self.messageTypeSegmentedControl.layer.borderWidth = 2
    }
        
    func setupInputTextView() {
        let color = getUIColor(hex: "#66CD5D")
        //This protocol defines a set of methods  the gets triggered when the text is being edited. We will hide the placeholder text while the text is being edited.
        inputTextView.delegate = self
        inputTextView.backgroundColor = UIColor.black
        inputTextView.layer.borderColor = UIColor.green.cgColor
        inputTextView.layer.borderWidth = 2
        inputTextView.layer.cornerRadius = 10
        inputTextView.textColor = UIColor.white

        //If the text box is empty then it will be the default sizr by constraints; however, if you are typing then the box will expand dnamically.
        // ^^^ Maybe????? Rewatch first section
        placeholderLbl.isHidden = false
        
        sendBtn.isEnabled = false
        sendBtn.setTitleColor(.lightGray, for: UIControl.State.normal)

        let placeholderX: CGFloat = self.view.frame.size.width / 75
        let placeholderY: CGFloat = 0
        let placeholderWidth: CGFloat = inputTextView.bounds.width - placeholderX
        
        let placeholderHeight: CGFloat = inputTextView.bounds.height
        
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLbl.text = "Write a message"
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = .lightGray
        placeholderLbl.textAlignment = .left
        
        inputTextView.addSubview(placeholderLbl)
    }
    
    func setupSearchBarController() {
        //https://stackoverflow.com/questions/24380535/how-to-apply-gradient-to-background-view-of-ios-swift-app
        let backgroundColor = getUIColor(hex: "#1A1A1A")
        let color = getUIColor(hex: "#ACACAC")

        //front end characterists of the searchbar
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search playlist..."
        searchController.searchBar.backgroundColor = backgroundColor
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = color
            textfield.textColor = UIColor.white
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // Applying tint colors to the buttons... make them our green color later
    func setupInputContainer() {
        let mediaImg = UIImage(named: "attachment_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        mediaButton.setImage(mediaImg, for: UIControl.State.normal)
        mediaButton.tintColor = .lightGray
        
        let micImg = UIImage(named: "mic")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        audioButton.setImage(micImg, for: UIControl.State.normal)
        audioButton.tintColor = .lightGray
    }
    
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


/*
 // Not using in this phase.. see video 35
 // Media selection for message attachment.
 
 @IBAction func attachmentBtnDidTap(_ sender: Any) {
     
     let alert = UIAlertController(title: "JChat", message: "Select source", preferredStyle: UIAlertController.Style.actionSheet)
     let camera = UIAlertAction(title: "Take a picture", style: UIAlertAction.Style.default) { (_) in
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
             self.picker.sourceType = .camera
             self.present(self.picker, animated: true, completion: nil)
             
         } else {
             print("Unavailable")
         }
     }
     
     let library = UIAlertAction(title: "Choose an Image or a video", style: UIAlertAction.Style.default) { (_) in
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
             self.picker.sourceType = .photoLibrary
             self.picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
             
             self.present(self.picker, animated: true, completion: nil)
         } else {
             print("Unavailable")
         }
     }
     
     let videoCamera = UIAlertAction(title: "Take a video", style: UIAlertAction.Style.default) { (_) in
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
             self.picker.sourceType = .camera
             self.picker.mediaTypes = [String(kUTTypeMovie)]
             self.picker.videoExportPreset = AVAssetExportPresetPassthrough
             //Duration limit is in seconds...
             self.picker.videoMaximumDuration = 30
             self.present(self.picker, animated: true, completion: nil)
             
         } else {
             print("Unavailable")
         }
     }
     
     let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
     alert.addAction(camera)
     alert.addAction(cancel)
     alert.addAction(videoCamera)
     alert.addAction(library)
     
     present(alert, animated: true, completion: nil)
 }
 */
