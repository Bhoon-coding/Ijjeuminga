//
//  LiveActivityManager.swift
//  Ijjeuminga
//
//  Created by BH on 9/3/24.
//

import ActivityKit
import Common
import Foundation

class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var activity: Activity<WidgetExtensionAttributes>?
    
    func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            // TODO: [] 권한 재요청 팝업 필요
            print("ActivitiesEnabled is false")
            return
        }
        
        let attribute = WidgetExtensionAttributes(currentBusStopInfo: "이번 정류장")
        let content = ActivityContent(
            state: WidgetExtensionAttributes.ContentState(
                busNumber: "9501",
                currentBusStop: "마천지구버스차고지",
                stopLeft: 3,
                totalStop: 10
            ),
            staleDate: Date().addingTimeInterval(60 * 5)
        )
        
        do {
            self.activity = try Activity<WidgetExtensionAttributes>.request(
                attributes: attribute,
                content: content
            )
            print("activity: \(String(describing: activity))")
        } catch {
            print("activity error: \(error.localizedDescription)")
        }
    }
    
    func stopLiveActivity() {
        Task {
            self.activity?.end(_:dismissalPolicy:)
        }
    }
    
    func updateLiveActivity() {
        Task {
            let newContent = ActivityContent(
                state: WidgetExtensionAttributes.ContentState(
                    busNumber: "6002",
                    currentBusStop: "동탄호수공원",
                    stopLeft: 1,
                    totalStop: 10
                ),
                staleDate: Date().addingTimeInterval(60 * 5)
            )
            await self.activity?.update(newContent)
        }
    }
}
