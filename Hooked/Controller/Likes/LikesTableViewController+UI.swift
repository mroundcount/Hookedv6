//
//  LikesTableViewController+UI.swift
//  Hooked
//
//  Created by Michael Roundcount on 11/13/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import Foundation
import UIKit

extension LikesTableViewController {
    
    func setUpUI() {
        setupNavigationBar()
        setUpBackground()
        setupSearchBarController()
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.view.backgroundColor = color
        self.tableView.backgroundColor = color
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func centerTitle(){
        for navItem in(self.navigationController?.navigationBar.subviews)! {
             for itemSubView in navItem.subviews {
                 if let largeLabel = itemSubView as? UILabel {
                    largeLabel.center = CGPoint(x: navItem.bounds.width/2, y: navItem.bounds.height/2)
                    return;
                 }
             }
        }
    }
    
    func setupNavigationBar() {
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Liked Songs"
        //navigationController?.navigationBar.prefersLargeTitles = true
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

