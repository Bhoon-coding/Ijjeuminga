//
//  RealTimeBusLocationDataSource.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Common

enum RealTimeBusLocationSectionData: Hashable {
    case bus(busType: KoreaBusType, data: [RealTimeBusLocationData])
    
    var items: [RealTimeBusLocationData] {
        switch self {
        case .bus(_, let data):
            return data
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .bus:
            hasher.combine("bus")
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .bus:
            switch rhs {
            case .bus:
                return true
            }
        }
    }
}

struct RealTimeBusLocationData: Hashable {
    let name: String
    let type: BusStopStatusType
    let isEmpty: Bool
    let uuid = UUID().uuidString
    
    init(name: String, type: BusStopStatusType) {
        self.name = name
        self.type = type
        self.isEmpty = name == "정류장에 대한 정보가 없습니다"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("name")
        hasher.combine(type.rawValue)
        hasher.combine(uuid)
    }
}

class RealTimeBusLocationDataSource: BaseTableDiffableDataSoceurce<RealTimeBusLocationSectionData, RealTimeBusLocationData>, 
                                        UITableViewDelegate {
    
    override func bind(_ tableView: UITableView) {
        super.bind(tableView)
        
        tableView.delegate = self
    }
    
    override func cellForRow(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             _ itemIdentifier: RealTimeBusLocationData) 
    -> UITableViewCell? {
        guard let section = dataSource.sectionIdentifier(for: 0),
              let cell = tableView.dequeueReusableCell(withIdentifier: BusStopStatusTableViewCell.id,
                                                       for: indexPath) as? BusStopStatusTableViewCell else {
            return nil
        }
        
        switch section {
        case .bus(busType: let busType, _):
            cell.configureCell(data: (busType, itemIdentifier, indexPath.row))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let position = BusStopPositionType(rawValue: indexPath.row) else {
            return 0
        }
        
        switch position {
        case .top:
            return 60
        case .topMiddle:
            return 110
        case .middle:
            return 110
        case .bottomMiddle:
            return 110
        case .bottom:
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
