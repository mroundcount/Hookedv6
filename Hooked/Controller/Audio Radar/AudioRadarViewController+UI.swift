//
//  AudioRadarViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 12/14/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit


extension AudioRadarViewController {
    
    func setUpUI() {
        setUpButtons()
        setUpBackground()
        setupNavigationBar()
        setUpLoadingInidcator()
    }
    
    func setUpLoadingInidcator() {
        let color = getUIColor(hex: "#66CD5D")
        self.loadingInidcator.color = color
        self.loadingInidcator.backgroundColor = .clear
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
    }
    
    func centerTitle(){
        for navItem in(self.navigationController?.navigationBar.subviews)! {
             for itemSubView in navItem.subviews {
                 if let largeLabel = itemSubView as? UILabel {
                    largeLabel.center = CGPoint(x: navItem.bounds.width/2, y: navItem.bounds.height/4)
                    return;
                 }
             }
        }
    }
    
    func setupNavigationBar() {
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpButtons() {
        
        nopeImg.isUserInteractionEnabled = true
        let tapNopeImg = UITapGestureRecognizer(target: self, action: #selector(nopeImgDidTap))
        nopeImg.addGestureRecognizer(tapNopeImg)
        nopeImg.image = UIImage(named: "radarDislike")
        
        likeImg.isUserInteractionEnabled = true
        let tapLikeImg = UITapGestureRecognizer(target: self, action: #selector(likeImgDidTap))
        likeImg.addGestureRecognizer(tapLikeImg)
        likeImg.image = UIImage(named: "radarLike")
         
        playImg.isUserInteractionEnabled = true
        let tapPlayImg = UITapGestureRecognizer(target: self, action: #selector(playImgDidTap))
        playImg.addGestureRecognizer(tapPlayImg)
        playImg.image = UIImage(systemName: "play.circle.fill")
        
        recordStatus = "Opening"
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

