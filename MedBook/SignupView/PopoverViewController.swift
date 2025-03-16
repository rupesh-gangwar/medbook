//
//  PopoverViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 15/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Password should have atleast 8 charecters, Must contain a uppercase letter, a special charecter and a number"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        label.frame = view.bounds
    }
}
