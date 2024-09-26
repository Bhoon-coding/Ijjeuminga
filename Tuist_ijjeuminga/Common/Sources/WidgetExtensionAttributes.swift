//
//  WidgetExtensionAttributes.swift
//  Common
//
//  Created by BH on 9/5/24.
//

import ActivityKit
import SwiftUI

// TODO: - 변수명 변경 (WidgetExtension → RealTimeStatus)
public struct WidgetExtensionAttributes: ActivityAttributes {
    public typealias RealTimeState = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        public var busNumber: String
        public var currentBusStop: String
        public var remainingBusStopCount: Int
        
        public init(busNumber: String, currentBusStop: String, remainingBusStopCount: Int) {
            self.busNumber = busNumber
            self.currentBusStop = currentBusStop
            self.remainingBusStopCount = remainingBusStopCount
        }
    }

    // Fixed non-changing properties about your activity go here!
    public var totalStop: Int
    public var busType: KoreaBusType.RawValue
    
    public init(totalStop: Int, busType: KoreaBusType.RawValue) {
        self.totalStop = totalStop
        self.busType = busType
    }
}
