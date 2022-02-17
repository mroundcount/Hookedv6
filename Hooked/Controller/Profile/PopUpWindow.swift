//
//  PopUpWindow.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/18/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit

protocol PopUpDelegate {
    func handleDismissal()
    func navigateToUpload()
    func navigateToWebsite()
}

class PopUpWindow: UIView {
    
    // MARK: - Properties
    var delegate: PopUpDelegate?
    
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


    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 16)
        label.text = "Hooked now has a website to upload music from your computer. Visit our website on your desktop or continue to upload it from your phone."
        label.textColor = UIColor.white
        
        return label
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 16)
        label.text = "https://hookedmusic.app/"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()

    let AppUploadBtn: UIButton = {
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
        
        let color = getUIColor(hex: "#66CD5D")
        
        let AppUploadBtn = UIButton(type: .system)
        AppUploadBtn.backgroundColor = color
        AppUploadBtn.setTitle("Upload on this app", for: .normal)
        AppUploadBtn.setTitleColor(.white, for: .normal)
        AppUploadBtn.addTarget(self, action: #selector(navigateToUpload), for: .touchUpInside)
        AppUploadBtn.translatesAutoresizingMaskIntoConstraints = false
        AppUploadBtn.layer.cornerRadius = 5
        AppUploadBtn.clipsToBounds = true
        //AppUploadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return AppUploadBtn
    }()
    
    let websiteBtn: UIButton = {
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
        let color = getUIColor(hex: "#66CD5D")
        
        let websiteBtn = UIButton(type: .system)
        websiteBtn.backgroundColor = color
        websiteBtn.setTitle("Go to our website", for: .normal)
        websiteBtn.setTitleColor(.white, for: .normal)
        websiteBtn.addTarget(self, action: #selector(navigateToWebsite), for: .touchUpInside)
        websiteBtn.translatesAutoresizingMaskIntoConstraints = false
        websiteBtn.layer.cornerRadius = 5
        websiteBtn.clipsToBounds = true
        return websiteBtn
    }()
    
    let cancelBtn: UIButton = {
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
        let color = getUIColor(hex: "#66CD5D")
        
        let cancelBtn = UIButton(type: .system)
        cancelBtn.backgroundColor = color
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.layer.cornerRadius = 5
        return cancelBtn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(notificationLabel)
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        notificationLabel.numberOfLines = 0
        
        addSubview(websiteLabel)
        websiteLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        websiteLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 10).isActive = true
        websiteLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        websiteLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        websiteLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        addSubview(AppUploadBtn)
        AppUploadBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        AppUploadBtn.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 10).isActive = true
        AppUploadBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        AppUploadBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        AppUploadBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
                
        addSubview(websiteBtn)
        websiteBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        websiteBtn.topAnchor.constraint(equalTo: AppUploadBtn.bottomAnchor, constant: 10).isActive = true
        websiteBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        websiteBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        websiteBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(cancelBtn)
        cancelBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: websiteBtn.bottomAnchor, constant: 10).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        cancelBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    @objc func navigateToUpload() {
        delegate?.navigateToUpload()
    }
    @objc func navigateToWebsite() {
        delegate?.navigateToWebsite()
    }
    
}

extension UIColor {
    static func mainBlue() -> UIColor {
        return UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
}

