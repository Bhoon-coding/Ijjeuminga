//
//  IjjeumingaWidgetLiveActivity.swift
//  IjjeumingaWidget
//
//  Created by 조성빈 on 8/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct IjjeumingaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct IjjeumingaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IjjeumingaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension IjjeumingaWidgetAttributes {
    fileprivate static var preview: IjjeumingaWidgetAttributes {
        IjjeumingaWidgetAttributes(name: "World")
    }
}

extension IjjeumingaWidgetAttributes.ContentState {
    fileprivate static var smiley: IjjeumingaWidgetAttributes.ContentState {
        IjjeumingaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: IjjeumingaWidgetAttributes.ContentState {
         IjjeumingaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: IjjeumingaWidgetAttributes.preview) {
   IjjeumingaWidgetLiveActivity()
} contentStates: {
    IjjeumingaWidgetAttributes.ContentState.smiley
    IjjeumingaWidgetAttributes.ContentState.starEyes
}
