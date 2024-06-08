//
//  Extension + UITextField.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import UIKit.UITextField

extension UITextField {
    
    func setBaseTextField() {
        let padding = CGRect(x: 0, y: 0, width: 16, height: 0)
        self.leftView = UIView(frame: padding)
        self.leftViewMode = .always
        self.layer.cornerRadius = 16
        self.backgroundColor = .gray95
    }
}

