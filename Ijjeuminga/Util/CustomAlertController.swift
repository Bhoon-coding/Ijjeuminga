//
//  CustomAlertController.swift
//  Ijjeuminga
//
//  Created by BH on 2024/07/16.
//

import UIKit.UIAlertController

class CustomAlertController {
    
    private let alertVC  = UIAlertController(title: "", message: "", preferredStyle: .alert)
    private var titleMsg: String = ""
    private var contentMsg: String = ""
    private var actions: [UIAlertAction] = []
    private var action: UIAlertAction = UIAlertAction()
    private var preferredAction: UIAlertAction?

    func setTitleMessage(_ message: String) -> CustomAlertController {
        self.titleMsg = message
        return self
    }
    
    func setContentMessage(_ message: String) -> CustomAlertController {
        self.contentMsg = message
        return self
    }
    
    func addaction(
        _ title: String?,
        _ style: UIAlertAction.Style,
        _ handler: ((UIAlertAction) -> Void)? = nil
    ) -> CustomAlertController {
        action = .init(title: title, style: style, handler: handler)
        self.actions.append(action)
        return self
    }
    
    func setPreferredAction(action: UIAlertAction.Style) -> CustomAlertController {
        if let preferred = actions.first(where: { $0.style == action }) {
            self.preferredAction = preferred
        } else {
            preferredAction = nil
        }
        return self
    }
    
    func build() -> UIAlertController {
        alertVC.title = self.titleMsg
        alertVC.message = self.contentMsg
        actions.forEach { alertVC.addAction($0) }
        
        if let preferredAction = preferredAction {
            alertVC.preferredAction = preferredAction
        }
        
        return alertVC
    }
}
