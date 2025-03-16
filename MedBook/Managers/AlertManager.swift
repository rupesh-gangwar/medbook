//
//  AlertManager.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 15/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showOneButtonAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
