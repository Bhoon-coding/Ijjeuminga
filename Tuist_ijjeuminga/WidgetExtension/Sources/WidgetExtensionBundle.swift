//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by BH on 9/4/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
