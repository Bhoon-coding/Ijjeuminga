//
//  Extension + Font.swift
//  Common
//
//  Created by BH on 9/10/24.
//

import SwiftUI

extension Font {
    public static func bold(_ size: CGFloat) -> Font {
        return CommonFontFamily.AppleSDGothicNeoB00.regular.swiftUIFont(size: size)
    }
    
    public static func regular(_ size: CGFloat) -> Font {
        return CommonFontFamily.AppleSDGothicNeoR00.regular.swiftUIFont(size: size)
    }
    
    public static func medium(_ size: CGFloat) -> Font {
        return CommonFontFamily.AppleSDGothicNeoM00.regular.swiftUIFont(size: size)
    }

}
