//
//  Extension + UIFont.swift
//  Ijjeuminga
//
//  Created by BH on 2024/08/30.
//

import UIKit.UIFont
// TODO: [] Common으로 옮기기
extension UIFont {
    static func bold(_ size: CGFloat) -> UIFont {
        return IjjeumingaFontFamily.AppleSDGothicNeoB00.regular.font(size: size)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return IjjeumingaFontFamily.AppleSDGothicNeoR00.regular.font(size: size)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return IjjeumingaFontFamily.AppleSDGothicNeoM00.regular.font(size: size)
    }
}
