//
//  CustomExtensions.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // least one uppercase
        // least one digit
        // least one special symbol
        // min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
}

extension UIView {
    func showLoader() {
        let loaderView  = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        loaderView.tag = 9999
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let loader = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        loader.center = loaderView.center
        loader.style = .large
        loader.color = UIColor.darkGray
        loader.startAnimating()
        loaderView.addSubview(loader)
        self.addSubview(loaderView)
    }

    func dismissLoader() {
        self.viewWithTag(9999)?.removeFromSuperview()
    }
}

extension UIButton {

    func customizeButton(title: String) {
        
        titleLabel?.text = title
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

}

extension UILabel {

    func customizeLabel(title: String) {
        
        self.text = title
    }

}

extension UITextField {

    func customizeTextField(placeholder: String) {
        
        self.placeholder = placeholder
    }

}
