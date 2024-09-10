//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by BH on 9/4/24.
//
import Common
import SwiftUI
import WidgetKit

struct ActivityView: View {
    let context: ActivityViewContext<WidgetExtensionAttributes>
    
    var body: some View {
        let attribute = context.attributes
        let state = context.state
        
        let totalStop = attribute.totalStop
        let remaingBusStopCount = state.remainingBusStopCount
        let percentageValue = 100 - (Double(remaingBusStopCount) / Double(totalStop) * 100)
        
        VStack(spacing: 24) {
            // 상단 (로고 | 버스번호)
            HStack {
                Image(asset: CommonAsset.logoRotate)
                    .resizable()
                    .frame(width: 40, height: 10)
                Spacer()
                Text(state.busNumber)
                    .foregroundStyle((setColor(with: attribute.busType)))
                    .fontWeight(.bold)
            }
            
            // MARK: - 중간 (이번 정류장 | 정류장 이름 | 목적지 ~ 남음)
            HStack {
                Text("이번 정류장")
                    .font(.regular(14))
                
                Spacer()
                
                Text(state.currentBusStop)
                    .font(.bold(20)) // 디자인 요구사항: 24px
                    .foregroundStyle(.green)
                    .lineLimit(2)
                
                Spacer()
                
                Text("\(state.remainingBusStopCount) 정거장 남음")
                    .font(.regular(14))
                    
            }
            .foregroundStyle(CommonAsset.subtitleText.swiftUIColor)
            
            // MARK: - ProgressBar
            ZStack {
                withAnimation {
                    ProgressView(value: percentageValue, total: 100.0)
                        .tint(.green)
                }
                
                GeometryReader { geometry in
                    Image(asset: CommonAsset.Positions.greenIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .position(
                            x: (geometry.size.width - 8) * CGFloat(percentageValue / 100.0),
                            y: geometry.size.height / 2
                        )
                    Image(asset: CommonAsset.Positions.arriveIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .position(
                            x: geometry.size.width - 8,
                            y: geometry.size.height / 2
                        )
                }
            }
            
        }
        .padding()
    }
    
    func setColor(with busType: KoreaBusType.RawValue) -> Color {
        return KoreaBusType(rawValue: busType)?.colors.swiftUIColor ?? .blueBus
    }
}

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            // MARK: - Widget
            ActivityView(context: context)
            
            // MARK: - DynamicIsland (보류)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom ")
                    // more content
                }
            } compactLeading: {
//                Text("L")
            } compactTrailing: {
//                Text("T ")
            } minimal: {
//                Text("Test minimal")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetExtensionAttributes {
    fileprivate static var preview: WidgetExtensionAttributes {
        WidgetExtensionAttributes(totalStop: 7, busType: KoreaBusType(rawValue: 1)?.rawValue ?? 2)
    }
}

#Preview(as: .content,
         using: WidgetExtensionAttributes.preview,
         widget: {
    WidgetExtensionLiveActivity()
}, contentStates: {
    WidgetExtensionAttributes.RealTimeState(
        busNumber: "6002",
        currentBusStop: "동탄호수공원", 
        remainingBusStopCount: 0
    )
})
