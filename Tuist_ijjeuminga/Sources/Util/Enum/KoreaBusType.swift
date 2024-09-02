//
//  KoreaBusType.swift
//  Ijjeuminga
//
//  Created by hayeon on 8/17/24.
//

import UIKit

enum KoreaBusType: Int {
    case seoulGanseonBus = 1
    case jiseonBus = 2
    case seoulSunhwanBus = 3
    case seoulGwangyeokBus = 4
    case maeulBus = 5
    case gonghangBus = 6
    
    var title: String {
        switch self {
        case .seoulGanseonBus:
            return "서울 간선버스"
        case .jiseonBus:
            return "지선버스"
        case .seoulSunhwanBus:
            return "서울 순환버스"
        case .seoulGwangyeokBus:
            return "서울 광역버스"
        case .maeulBus:
            return "마을버스"
        case .gonghangBus:
            return "공항버스"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .seoulGanseonBus:
            return .blue
        case .jiseonBus:
            return .greenBus
        case .seoulSunhwanBus:
            return .yellowBus
        case .seoulGwangyeokBus:
            return .redBus
        case .maeulBus:
            return .greenBus
        case .gonghangBus:
            return .brown
        }
    }
}
