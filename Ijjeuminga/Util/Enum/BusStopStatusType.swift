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
    
    var title: String {
        switch self {
        case .next:
            return "다음 정류장"
        case .current:
            return "이번 정류장"
        default:
            return ""
        }
    }
    
    var font: UIFont {
        switch self {
        case .current:
            return UIFont(name: Font.sandollGothicBold, size: 26) ?? .boldSystemFont(ofSize: 26)
        case .next, .previous:
            return UIFont(name: Font.sandollGothicBold, size: 16) ?? .boldSystemFont(ofSize: 16)
        case .destination, .twoStopsAgo:
            return UIFont(name: Font.sandollGothicBold, size: 14) ?? .boldSystemFont(ofSize: 14)
        }
    }
    
    var titleFont: UIFont? {
        switch self {
        case .next:
            return UIFont(name: Font.sandollGothicBold, size: 13) ?? .boldSystemFont(ofSize: 13)
        case .current:
            return UIFont(name: Font.sandollGothicBold, size: 16) ?? .boldSystemFont(ofSize: 16)
        default:
            return nil
        }
    }
}
