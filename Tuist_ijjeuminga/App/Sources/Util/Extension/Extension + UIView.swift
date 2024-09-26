//
//  Extension+UIView.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/4/24.
//

import UIKit.UIView

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
    
    func setConstraintsToMatch(_ superView: UIView,
                               top: CGFloat = 0,
                               leading: CGFloat = 0,
                               trailing: CGFloat = 0,
                               bottom: CGFloat = 0,
                               safeArea: Bool = true) {
        if safeArea {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: top),
                self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: leading),
                self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -trailing),
                self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -bottom)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: top),
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading),
                self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -trailing),
                self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottom)
            ])
        }
    }
    
    func addTapAction(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
}
