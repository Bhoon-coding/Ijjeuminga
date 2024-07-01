//
//  Extension+UIView.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/4/24.
//

import UIKit

extension UIView {
    func setConstraintsToMatch(_ superView: UIView, constant: CGFloat = 0, safeArea: Bool = true) {
        if safeArea {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: constant),
                self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: constant),
                self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -constant),
                self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -constant)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant),
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant),
                self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant),
                self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant)
            ])
        }
    }
}
