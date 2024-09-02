//
//  Extension+NSLayoutConstraint.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit

extension NSLayoutConstraint {
    var withActive: NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
