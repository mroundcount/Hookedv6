//
//  PreferenceTableViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 4/16/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import Foundation

class PreferenceTableViewController: UITableViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    
    
    let genre = ["Alternative Rock", /*"Ambient",*/ "Classical", "Country", "Dance & EDM", /*"Dancehall", "Deep House",*/ "Disco", /*"Drum & Bass", "Dubstep", "Electronic",*/ "Folk", "Hip-hop & Rap",/* "House",*/ "Indie", "Jazz & Blues", "Latin", "Metal", "Piano", "Pop", "R&B & Soul", "Reggae", "Reggaeton", "Rock", /*"Techno", "Trance", "Trap", "Triphop",*/ "World"]
    
    var preference: Preferences!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavigationBar()
        setUpUI()
    }
    /*
    func setupNavigationBar() {
        navigationItem.title = "Preferred Genres"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let back = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = back
        
        let save = UIBarButtonItem(title: "Reset", style: UIBarButtonItem.Style.plain, target: self, action: #selector(resetBtnDidTap))
        navigationItem.rightBarButtonItem = save
    } */
    
    func setUpUI() {
        setUpBackBtn()
        setUpBackground()
        setUpLbl()
        setUpResetBtn()
    }
    
    func setUpBackBtn() {
        backBtn.setImage(UIImage(named: "close-1"), for: .normal)
        backBtn.tintColor = .white
        backBtn.backgroundColor = UIColor.gray
        backBtn.layer.cornerRadius = 15
        backBtn.clipsToBounds = true
    }
    
    func setUpBackground() {
        let color = getUIColor(hex: "#1A1A1A")
        self.backgroundView.backgroundColor = color
        self.tableView.backgroundColor = color
    }
    
    func setUpLbl() {
        let color = getUIColor(hex: "#1A1A1A")
        self.titleLbl.text = "Genre Preferences"
        self.titleLbl.textColor = .white
        self.titleLbl.backgroundColor = color
    }
    
    func setUpResetBtn() {
        let color = getUIColor(hex: "#66CD5D")
        self.resetBtn.setTitle("Reset", for: UIControl.State.normal)
        self.resetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.resetBtn.titleLabel?.textColor = UIColor.white
        self.resetBtn.tintColor = UIColor.white
        
        self.resetBtn.backgroundColor = color
        self.resetBtn.layer.cornerRadius = 5
        self.resetBtn.clipsToBounds = true
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        print("back")
        navigationController?.popViewController(animated: true)
    }

    @IBAction func resetBtnDidTap(_ sender: Any) {
        print("saved")
        resetPreferences()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genre.count
    }
    
    //Loading the view with the current preferences
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let color = getUIColor(hex: "#1A1A1A")
        let checkColor = getUIColor(hex: "#66CD5D")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = genre[indexPath.row]
        cell.backgroundColor = color
        cell.tintColor = checkColor
        
        Api.Preferences.getUserPreferencesforSingleEvent(user: Api.User.currentUserId) { (preference) in
            print("in the single event function")
            
            if cell.textLabel?.text == "Alternative Rock" && preference.alternativeRock == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Ambient" && preference.ambient == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Classical" && preference.classical == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Country" && preference.country == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Dance & EDM" && preference.danceEDM == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Dancehall" && preference.dancehall == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Deep House" && preference.deepHouse == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Disco" && preference.disco == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Drum & Bass" && preference.drumBass == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Dubstep" && preference.dubstep == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Electronic" && preference.electronic == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Folk" && preference.folk == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Hip-hop & Rap" && preference.hipHopRap == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "House" && preference.house == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Indie" && preference.indie == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Jazz & Blues" && preference.jazzBlues == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Latin" && preference.latin == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Metal" && preference.metal == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Piano" && preference.piano == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Pop" && preference.pop == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "R&B & Soul" && preference.RBSoul == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Reggae" && preference.raggae == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Reggaeton" && preference.reggaeton == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Rock" && preference.rock == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Techno" && preference.techno == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Trance" && preference.trance == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Trap" && preference.trap == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "Triphop" && preference.triphop == true {
                cell.accessoryType = .checkmark
            }
            if cell.textLabel?.text == "World" && preference.world == true {
                cell.accessoryType = .checkmark
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Adding and removing values to the array
        //https://stackoverflow.com/questions/48845607/save-an-array-of-multiple-selected-uitableviewcell-values
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                
                //removing the selected preference for the node
                print("removing: \(genre[indexPath.row])")
                
                let selection = genre[indexPath.row]
                let reference = Ref().databasePreferencesUser(user: Api.User.currentUserId).child(selection)
                
                let pref = false
                Ref().databasePreferencesUser(user: Api.User.currentUserId)
                    .updateChildValues([genre[indexPath.row]: pref]) { (error, ref) in
                        if error == nil, pref == false {
                        }
                }
                
            } else {
                cell.accessoryType = .checkmark
                //adding the selected preference for the node
                let pref = true
                Ref().databasePreferencesUser(user: Api.User.currentUserId)
                    .updateChildValues([genre[indexPath.row]: pref]) { (error, ref) in
                        if error == nil, pref == true {
                        }
                }
            }
        }
    }
    
    func resetPreferences() {
        let pref = true
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Alternative Rock" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Ambient" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Classical" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Country" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dance & EDM" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dancehall" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Deep House" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Disco" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Drum & Bass" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Dubstep" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Electronic" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Folk" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Hip-hop & Rap" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["House" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Indie" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Jazz & Blues" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Latin" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Metal" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Piano" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Pop" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["R&B & Soul" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Reggae" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Reggaeton" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Rock" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Techno" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Trance" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Trap" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["Triphop" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        Ref().databasePreferencesUser(user: Api.User.currentUserId)
            .updateChildValues(["World" : pref]) { (error, ref) in
                if error == nil, pref == true {
                }
        }
        tableView.reloadData()
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
