//
//  DestinationSearchedTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/07/04.
//

import UIKit

class DestinationSearchedTableViewCell: BaseTableViewCell<UITableViewCell> {

    static let identifier: String = "DestinationSearchedTableViewCell"
    
    private weak var directionIcon: UIImageView!
    private weak var busStationLabel: UILabel!
    private weak var nextBusStationLabel: UILabel!
    
    override func initView() {
        super.initView()
        
        let directionIcon = UIImageView()
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.image = .directionIcon
        contentView.addSubview(directionIcon)
        self.directionIcon = directionIcon
        
        let busStationLabel = UILabel()
        busStationLabel.translatesAutoresizingMaskIntoConstraints = false
        busStationLabel.text = "정보 없음"
        busStationLabel.textColor = .busStopText
        busStationLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(busStationLabel)
        self.busStationLabel = busStationLabel
        
        let nextBusStationLabel = UILabel()
        nextBusStationLabel.translatesAutoresizingMaskIntoConstraints = false
        nextBusStationLabel.text = "다음 정류장 정보 없음"
        nextBusStationLabel.textColor = .redBus
        nextBusStationLabel.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(nextBusStationLabel)
        self.nextBusStationLabel = nextBusStationLabel
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            directionIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  8),
            directionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            directionIcon.widthAnchor.constraint(equalToConstant: 16),
            directionIcon.heightAnchor.constraint(equalToConstant: 16),
            
            busStationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStationLabel.leadingAnchor.constraint(equalTo: directionIcon.trailingAnchor, constant: 32),
            
            nextBusStationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nextBusStationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    internal func setupCell(with station: Rest.BusRouteInfo.ItemList, _ nextStation: String?) {
        self.busStationLabel.text = station.stationNm
        self.nextBusStationLabel.text = (nextStation ?? "종점") + " 방향"
    }

}

#Preview {
    DestinationSearchedTableViewCell()
}
