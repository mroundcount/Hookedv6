//
//  ViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var signInFacebookBtn: UIButton!
    @IBOutlet weak var signInGoogleBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var termsOfServiceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //Onboarding
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let vc = storyboard?.instantiateViewController(identifier: "onboard") as! OnboardViewController
        //Comment the if statement this for testing and modifying the onboarding so it comes up every time.
        if Core.shared.isNewUser(){
            //show onboarding
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func setUpUI() {
        //remeber to right click and "jump to definition"
        //Find all methods in the ViewController+UI.swift file
        setUpHeaderTitle()
        setUpOrLabel()
        setUpFacebookBtn()
        setUpGoogleBtn()
        setUpCreateAccountBtn()
        setUpTermsLabel()
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        
        let alert = UIAlertController(title: "Whoa there cowboy!", message: "Yeah, I didn't write any terms yet", preferredStyle: .alert)
        
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("Whatever dude!")
        }))
    }
}

class Core {
    static let shared = Core()
    
    //first time user
    func isNewUser() -> Bool{
        //returning the inverse since this will default to false
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    //User is not new and onboarding will not be displayed
    //Call this once the person has dismissed the welcome, so it is not shown again
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}

