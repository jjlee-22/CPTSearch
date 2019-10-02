//
//  ViewController.swift
//  CPTSearch
//
//  Description: CPTSearch is an iOS ordering app that searches for the correct imaging exam and processes the orders for the doctors
//
//  Created by Jonathan Lee on 9/16/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var navView: UIView!

    let backgroundImageView = UIImageView()
    
    
    
    @IBAction func navButtonTapped(_ sender: Any) {
        navView.isHidden = !navView.isHidden
    }
    
    // This method only runs after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Lindsey was here
        // Truc is here
        setBackground()
    }
    
    func setBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        backgroundImageView.image = UIImage(named: "blue.jpg")
    }
}

