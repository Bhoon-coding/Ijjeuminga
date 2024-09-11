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
    
    func startLiveActivity(
        busType: KoreaBusType.RawValue,
        busNum: String,
        currentBusStopName: String,
        remainingBusStopCount: Int,
        totalStop: Int
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            // TODO: [] 권한 재요청 팝업 필요
            print("ActivitiesEnabled is false")
            return
        }
        
        let attribute = WidgetExtensionAttributes(totalStop: remainingBusStopCount, busType: busType)
        let content = ActivityContent(
            state: WidgetExtensionAttributes.ContentState(
                busNumber: busNum,
                currentBusStop: currentBusStopName,
                remainingBusStopCount: remainingBusStopCount
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
        // TODO: [] 에러팝업 처리
            print("activity error: \(error.localizedDescription)")
        }
    }
    
    func stopLiveActivity() {
        let content = ActivityContent(
            state: WidgetExtensionAttributes.RealTimeState(
                busNumber: "",
                currentBusStop: "",
                remainingBusStopCount: 0
            ),
            staleDate: .now
        )
        
        Task {
            await activity?.end(content, dismissalPolicy: .after(Date().addingTimeInterval(60 * 5)))
        }
    }
    
    // TODO: [] api 호출 후 업데이트 되는 내용 여기에 반영
    func updateLiveActivity(
        busNum: String,
        currentBusStopName: String,
        remainingBusStopCount: Int
    ) {
        Task {
            let newContent = ActivityContent(
                state: WidgetExtensionAttributes.RealTimeState(
                    busNumber: busNum,
                    currentBusStop: currentBusStopName,
                    remainingBusStopCount: remainingBusStopCount
                ),
                staleDate: Date().addingTimeInterval(60 * 5)
            )
            await self.activity?.update(newContent)
        }
    }
}
