//
//  LaunchViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customizeUI()
    }

    private func customizeUI() {
        topLabel.customizeLabel(title: "MedBook")
        signupButton.customizeButton(title: "Signup")
        loginButton.customizeButton(title: "Login")
    }

}

