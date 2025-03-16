//
//  SignUpViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    private var countries: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.picker.reloadAllComponents()
                
            }
        }
    }
    private var selectedIndex: Int? {
        didSet {
            DispatchQueue.main.async {
                self.picker.selectRow(self.selectedIndex ?? 0, inComponent: 0, animated: true)
            }
        }
    }
    private var popoverViewController: PopoverViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
        fetchDefaultCountry()
        fetchCountryList()
    }
    
    private func customizeUI() {
        signupButton.customizeButton(title: "Let's go")
    }
    
    private func fetchCountryList() {
        view.showLoader()
        APIManager.shared.fetchCountryList { success in
            // remove activity indicator
            DispatchQueue.main.async {
                self.view.dismissLoader()
            }
            if success {
                // show country picker
                self.countries = DataBaseManager.shared.countryList()
                let country = UserDefaultsHelper.getDefaultCountry()
                for i in 0..<self.countries!.count {
                    if self.countries![i] == country?["name"] {
                        self.selectedIndex = i
                    }
                }
            } else {
                // show alert to retry
                self.showOneButtonAlert(title: "Error", message: "Some error occured, Please try after some time.")
            }
        }
    }
    
    private func fetchDefaultCountry() {
        APIManager.shared.fetchDefaultCountry()
    }

}

extension SignUpViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        let emailText = self.emailTextField.text
        let emailValid = emailText?.isValidEmail()
        if !(emailValid!) {
            // show alert
            showOneButtonAlert(title: "Error", message: "Please enter valid email.")
            return
        }
        
        let passwordText = self.passwordTextFiled.text
        let passwordValid = passwordText?.isValidPassword()
        if !(passwordValid!) {
            // show alert
            showOneButtonAlert(title: "Error", message: "Please enter valid password.")
            return
        }
        
        let success = DataBaseManager.shared.saveUserForSignUp(mail: emailText!, password: passwordText!, country: countries?[selectedIndex ?? 0] ?? "")
        if success {
            pushToHomeScreen()
        } else {
            showOneButtonAlert(title: "Error", message: "Email already exists.")
        }
    }
    
    private func pushToHomeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func showPopover(sender: UITextField) {
        
        if sender.text?.count ?? 0 > 1 {
            return
        }
        
        popoverViewController = PopoverViewController()
        popoverViewController?.preferredContentSize = .init(width: 220, height: 180)
        popoverViewController?.modalPresentationStyle = .popover
        
        let popoverPresentationController = popoverViewController?.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.sourceRect = sender.bounds
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.delegate = self

        present(popoverViewController!, animated: true, completion: nil)
    }
    
    private func removePopover() {
        if popoverViewController != nil {
            popoverViewController?.dismiss(animated: true, completion: nil)
            popoverViewController = nil
        }
    }
}

extension SignUpViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTextFiled {
            showPopover(sender: textField)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries?.count ?? 0
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(String(countries?[row] ?? ""))"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        print("\(String(countries?[row] ?? ""))")
    }
}
