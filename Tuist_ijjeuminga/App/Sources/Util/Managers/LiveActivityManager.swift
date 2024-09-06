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
                currentBusStop: "마전지구버스차고지",
                stopLeft: 3,
                totalStop: 10
            ),
            // TODO: [] 액티비티 시작시 언제까지 뜨게할지 논의 필요
            staleDate: Date().addingTimeInterval(60 * 5)
        )
        
        do {
            self.activity = try Activity<WidgetExtensionAttributes>.request(
                attributes: attribute,
                content: content
            )
        } catch {
            print("activity error: \(error.localizedDescription)")
        }
    }
    
    func stopLiveActivity() {
        let content = ActivityContent(
            state: WidgetExtensionAttributes.RealTimeState(
                busNumber: "",
                currentBusStop: "",
                stopLeft: 0,
                totalStop: 0
            ),
            staleDate: .now
        )
        
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
    
    // TODO: [] api 호출 후 업데이트 되는 내용 여기에 반영
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
