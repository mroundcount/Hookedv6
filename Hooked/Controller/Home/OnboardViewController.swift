//
//  OnboardViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/10/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
    //reference:
    //https://www.youtube.com/watch?v=7GFgmjZ4r2c&list=LL&index=1

    @IBOutlet var holderView: UIView!
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    private func configure() {
        //set up scrollview
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        
        //Adding the array of titles
        let titles = ["Right swipe clips you like", "Listen to full songs on your playlist", "If you're an artist, upload and manage music", "Don't forget to adjust your music preferences"]
        
        //Adding screens for the demo using a for loop
        for x in 0..<4 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            
            scrollView.addSubview(pageView)
            
            //title image, button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width-20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10+120+10, width: pageView.frame.size.width-20, height: pageView.frame.size.height-200-120-15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-60, width: pageView.frame.size.width-20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 26)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 3
            pageView.addSubview(label)
            label.text = titles[x]
            
            
            //Rememeber to check asset file
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Welcome_\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .purple
            button.setTitle("Continue", for: .normal)
            if x == 3 {
                button.setTitle("Get Started", for: .normal)
            }
            button.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
        }
        
        //Adding the ability to scroll
        scrollView.contentSize = CGSize(width: holderView.frame.size.width*4, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    @objc func didTabButton(_ button: UIButton) {
        guard button.tag < 4 else {
            //dismiss
            //setting that the user is not a new user anymore
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag) ,y: 0), animated: true)
    }
    

}
