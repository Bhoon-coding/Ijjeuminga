//
//  Extension + UIFont.swift
//  Common
//
//  Created by BH on 9/10/24.
//

import UIKit.UIFont

extension UIFont {
    public static func bold(_ size: CGFloat) -> UIFont {
        return CommonFontFamily.AppleSDGothicNeoB00.regular.font(size: size)
    }
    
    public static func regular(_ size: CGFloat) -> UIFont {
        return CommonFontFamily.AppleSDGothicNeoR00.regular.font(size: size)
    }
    
    public static func medium(_ size: CGFloat) -> UIFont {
        return CommonFontFamily.AppleSDGothicNeoM00.regular.font(size: size)
    }
}

