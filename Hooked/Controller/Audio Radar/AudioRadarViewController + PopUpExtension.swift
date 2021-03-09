//
//  AudioRadarViewController + PopUpExtension.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/15/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit


extension AudioRadarViewController {
    
    //Roundcount added 12/18 for pop up window
    @objc func handleShowPopUp() {
        view.addSubview(popUpWindow)
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
        }
    }
    //End

    func setUpPopUp() {
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("Did remove pop up window..")
        }
    }
    
    func navigateToUpload() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let uploadVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_UPLOAD) as! UploadTableViewController
        self.navigationController?.pushViewController(uploadVC, animated: true)
        handleDismissal()
    }
    
    func navigateToWebsite() {
        if let url = NSURL(string: "https://hooked-217d3.web.app/") {
            UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
        }
        handleDismissal()
    }
}
