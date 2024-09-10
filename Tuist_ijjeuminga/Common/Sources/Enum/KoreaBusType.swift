//
//  KoreaBusType.swift
//  Ijjeuminga
//
//  Created by hayeon on 8/17/24.
//

import SwiftUI
import UIKit

public enum KoreaBusType: Int {
    case seoulGanseonBus = 1
    case jiseonBus = 2
    case seoulSunhwanBus = 3
    case seoulGwangyeokBus = 4
    case maeulBus = 5
    case gonghangBus = 6
    
    public var title: String {
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
    
    public var colors: CommonColors {
        switch self {
        case .seoulGanseonBus:
            return CommonAsset.blueBus
        case .jiseonBus, .maeulBus:
            return CommonAsset.greenBus
        case .seoulSunhwanBus:
            return CommonAsset.yellowBus
        case .seoulGwangyeokBus:
            return CommonAsset.redBus
            // TODO: [] direction, position 색상 이미지 필요 (공항색도 변경필요)
        case .gonghangBus:
            return CommonAsset.brown
        }
    }
    
    public var directionImage: CommonImages {
        switch self {
        case .seoulGanseonBus:
            return CommonAsset.Directions.blue
        case .jiseonBus, .maeulBus:
            return CommonAsset.Directions.green
        case .seoulSunhwanBus:
            return CommonAsset.Directions.yellow
        case .seoulGwangyeokBus:
            return CommonAsset.Directions.red
        case .gonghangBus:
            return CommonAsset.Directions.yellow
        }
    }
    
    public var positionImage: CommonImages {
        switch self {
        case .seoulGanseonBus:
            return CommonAsset.Positions.yellowIcon
        case .jiseonBus, .maeulBus:
            return CommonAsset.Positions.redIcon
        case .seoulSunhwanBus:
            return CommonAsset.Positions.blueIcon
        case .seoulGwangyeokBus:
            return CommonAsset.Positions.greenIcon
        case .gonghangBus:
            return CommonAsset.Positions.yellowIcon
        }
    }
}
