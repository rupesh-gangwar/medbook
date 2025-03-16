//
//  LogInViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

final class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }
    
    private func customizeUI() {
        loginButton.customizeButton(title: "Login ->")
    }

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginClicked(sender: UIButton) {
        let isValid = DataBaseManager.shared.verifyUserCredentials(email: usernameTextField.text ?? "", password: passwordTextFiled.text ?? "")
        if isValid {
            UserDefaultsHelper.userLoggedIn()
            performSegue(withIdentifier: "PushHomeScreen", sender: nil)
        } else {
            // show wrong credentials alert
            showOneButtonAlert(title: "Alert", message: "Wrong email or password enered.")
        }
    }

}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
