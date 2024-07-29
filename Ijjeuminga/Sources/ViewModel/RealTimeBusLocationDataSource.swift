//
//  RealTimeBusLocationDataSource.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa

enum RealTimeBusLocationSectionData: Hashable {
    case bus(data: [RealTimeBusLocationData])
    
    var items: [RealTimeBusLocationData] {
        switch self {
        case .bus(let data):
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("name")
        hasher.combine(type.rawValue)
    }
}

class RealTimeBusLocationDataSource: BaseTableDiffableDataSoceurce<RealTimeBusLocationSectionData, RealTimeBusLocationData>, 
                                        UITableViewDelegate {
    
    override func cellForRow(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             _ itemIdentifier: RealTimeBusLocationData) 
    -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusStopStatusTableViewCell.id,
                                                       for: indexPath) as? BusStopStatusTableViewCell else {
            return nil
        }
        
        cell.configureCell(data: itemIdentifier)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
