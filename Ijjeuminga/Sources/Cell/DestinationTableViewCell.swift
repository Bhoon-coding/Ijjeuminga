//
//  DestinationTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import UIKit

final class DestinationTableViewCell: BaseTableViewCell<UITableViewCell> {
    
    static let identifier: String = "DestinationTableViewCell"
    
    private weak var busStopLabel: UILabel!

    override func initView() {
        super.initView()
        
        let busStopLabel = UILabel()
        busStopLabel.translatesAutoresizingMaskIntoConstraints = false
        busStopLabel.text = "알 수 없음"
        busStopLabel.textColor = UIColor(resource: .busStopText)
        contentView.addSubview(busStopLabel)
        self.busStopLabel = busStopLabel
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            busStopLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 86),
            busStopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
    internal func setupCell(item: Rest.BusRouteInfo.ItemList) {
        guard let stationName = item.stationNm else { return }
        busStopLabel.text = stationName
        
    }
}

#Preview {
    DestinationTableViewCell()
}
