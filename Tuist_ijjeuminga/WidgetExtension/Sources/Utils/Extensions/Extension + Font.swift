//
//  Extension + Font.swift
//  Common
//
//  Created by BH on 9/5/24.
//

import SwiftUI

extension Font {
    static func bold(_ size: CGFloat) -> Font {
        return WidgetExtensionFontFamily.AppleSDGothicNeoB00.regular.swiftUIFont(size: size)
    }
    
    static func regular(_ size: CGFloat) -> Font {
        return WidgetExtensionFontFamily.AppleSDGothicNeoR00.regular.swiftUIFont(size: size)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        return WidgetExtensionFontFamily.AppleSDGothicNeoM00.regular.swiftUIFont(size: size)
    }

}
