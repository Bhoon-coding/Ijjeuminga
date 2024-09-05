//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by BH on 9/4/24.
//
import Common
import SwiftUI
import WidgetKit

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            
            let attribute: WidgetExtensionAttributes = context.attributes
            let state: WidgetExtensionAttributes.ContentState = context.state
            
            let totalStop = 100.0
            let currentValue = 35.0
            
            VStack(spacing: 24) {
                // 상단 (로고 | 버스번호)
                HStack {
                    Text("이쯤인가(로고)")
                    Spacer()
                    Text(attribute.currentBusStopInfo)
                        .foregroundStyle(.red)
                        .fontWeight(.bold)
                }
                
                // MARK: - 중간 (이번 정류장 | 정류장 이름 | 목적지 ~ 남음)
                HStack {
                    Text(attribute.currentBusStopInfo)
                    Text(state.currentBusStop)
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("목적지까지 \(state.stopLeft)정거장 남음")
                }
                
                // MARK: - ProgressBar
                ZStack {
                    ProgressView(value: currentValue, total: totalStop)
                        .tint(.green)
                    
                    GeometryReader { geometry in
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.green)
                            .position(
                                x: geometry.size.width * CGFloat(currentValue / totalStop),
                                y: geometry.size.height / 2
                            )
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.blue)
                            .position(
                                x: geometry.size.width - 8,
                                y: geometry.size.height / 2
                            )
                    }
                }
                
            }
            .foregroundStyle(.black)
            .padding()
            .activityBackgroundTint(.init(red: 239, green: 240, blue: 243))
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom ")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T ")
            } minimal: {
                Text("Test minimal")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetExtensionAttributes {
    fileprivate static var preview: WidgetExtensionAttributes {
        WidgetExtensionAttributes(currentBusStopInfo: "이번 정류장")
    }
}
//
//extension WidgetExtensionAttributes.ContentState {
//    fileprivate static var smiley: WidgetExtensionAttributes.ContentState {
//        WidgetExtensionAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: WidgetExtensionAttributes.ContentState {
//         WidgetExtensionAttributes.ContentState(emoji: "🤩")
//     }
//}

#Preview(as: .content,
         using: WidgetExtensionAttributes.preview,
         widget: {
    WidgetExtensionLiveActivity()
},
         contentStates: {
    WidgetExtensionAttributes.ContentState(
        busNumber: 6002,
        currentBusStop: "동탄호수공원",
        stopLeft: 2,
        totalStop: 10
    )
})
