//
//  MainNavigationController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 16/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userStatus = UserDefaultsHelper.isUserLoggedIn()
        if userStatus {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.setViewControllers([homeView], animated: true)
        }
    }
    
    func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let launchView = storyboard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
        self.setViewControllers([launchView], animated: true)
    }
}
