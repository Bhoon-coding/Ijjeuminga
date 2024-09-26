//
//  BusStopStatusType.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit

enum BusStopStatusType: Int {
    case destination = 0
    case next = 1
    case current = 2
    case previous = 3
    case twoStopsAgo = 4
    
    var color: UIColor {
        switch self {
        case .destination:
            return .greenBus
        case .next:
            return .noticeText
        case .current:
            return .redBus
        case .previous:
            return .disabledText
        case .twoStopsAgo:
            return .disabledText
        }
    }
}

enum BusStopPositionType: Int {
    case top
    case topMiddle
    case middle
    case bottomMiddle
    case bottom
    
    var font: UIFont {
        switch self {
        case .middle:
            return UIFont(name: Font.sandollGothicBold, size: 26) ?? .boldSystemFont(ofSize: 26)
        case .topMiddle, .bottomMiddle:
            return UIFont(name: Font.sandollGothicBold, size: 16) ?? .boldSystemFont(ofSize: 16)
        case .top, .bottom:
            return UIFont(name: Font.sandollGothicBold, size: 14) ?? .boldSystemFont(ofSize: 14)
        }
    }
    
    var titleFont: UIFont? {
        switch self {
        case .topMiddle:
            return UIFont(name: Font.sandollGothicBold, size: 13) ?? .boldSystemFont(ofSize: 13)
        case .middle:
            return UIFont(name: Font.sandollGothicBold, size: 16) ?? .boldSystemFont(ofSize: 16)
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .topMiddle:
            return "다음 정류장"
        case .middle:
            return "이번 정류장"
        default:
            return ""
        }
    }
}
