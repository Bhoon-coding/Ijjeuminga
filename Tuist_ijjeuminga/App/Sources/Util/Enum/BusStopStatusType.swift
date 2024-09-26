//
//  BusStopStatusType.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit

enum BusStopStatusType: Int {
    case twoStopsNext = -1
    case destination = 0
    case next = 1
    case current = 2
    case previous = 3
    case twoStopsAgo = 4
    
    var color: UIColor {
        switch self {
        case .twoStopsNext:
            return .noticeText
        case .destination:
            return .greenBus
        case .next:
            return .noticeText
        case .current:
            return .redBus
        case .previous, .twoStopsAgo:
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
            return .bold(26)
        case .topMiddle, .bottomMiddle:
            return .bold(16)
        case .top, .bottom:
            return .bold(14)
        }
    }
    
    var titleFont: UIFont? {
        switch self {
        case .topMiddle:
            return .bold(13)
        case .middle:
            return .bold(16)
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
