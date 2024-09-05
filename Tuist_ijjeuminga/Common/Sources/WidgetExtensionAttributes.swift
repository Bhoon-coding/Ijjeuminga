//
//  WidgetExtensionAttributes.swift
//  Common
//
//  Created by BH on 9/5/24.
//

import ActivityKit

public struct WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        public var busNumber: Int
        public var currentBusStop: String
        public var stopLeft: Int
        public var totalStop: Int
        
        public init(busNumber: Int, currentBusStop: String, stopLeft: Int, totalStop: Int) {
            self.busNumber = busNumber
            self.currentBusStop = currentBusStop
            self.stopLeft = stopLeft
            self.totalStop = totalStop
        }
    }

    // Fixed non-changing properties about your activity go here!
    public var currentBusStopInfo: String
    
    public init(currentBusStopInfo: String) {
        self.currentBusStopInfo = currentBusStopInfo
    }
}
