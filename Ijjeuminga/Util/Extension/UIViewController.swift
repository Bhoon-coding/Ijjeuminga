//
//  UIViewController.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 7/21/24.
//

import UIKit

extension UIViewController {
    func getCurrentDateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date)
    }
}
