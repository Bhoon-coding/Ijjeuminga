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
    private weak var directionIcon: UIImageView!
    private weak var directionTopLine: UIView!
    private weak var directionBottomLine: UIView!

    override func initView() {
        super.initView()
        
        let directionIcon = UIImageView()
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.image = .directionIcon
        contentView.addSubview(directionIcon)
        self.directionIcon = directionIcon
        
        let directionTopLine = UIView()
        directionTopLine.translatesAutoresizingMaskIntoConstraints = false
        directionTopLine.backgroundColor = .redBus
        contentView.addSubview(directionTopLine)
        self.directionTopLine = directionTopLine
        
        let directionBottomLine = UIView()
        directionBottomLine.translatesAutoresizingMaskIntoConstraints = false
        directionBottomLine.backgroundColor = .redBus
        contentView.addSubview(directionBottomLine)
        self.directionBottomLine = directionBottomLine
        
        let busStopLabel = UILabel()
        busStopLabel.translatesAutoresizingMaskIntoConstraints = false
        busStopLabel.text = "강남역"
        busStopLabel.textColor = UIColor(resource: .busStopText)
        contentView.addSubview(busStopLabel)
        self.busStopLabel = busStopLabel
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            directionIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            directionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            directionIcon.widthAnchor.constraint(equalToConstant: 16),
            directionIcon.heightAnchor.constraint(equalToConstant: 16),
            
            directionTopLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            directionTopLine.bottomAnchor.constraint(equalTo: directionIcon.topAnchor),
            directionTopLine.leadingAnchor.constraint(equalTo: directionIcon.centerXAnchor),
            directionTopLine.widthAnchor.constraint(equalToConstant: 1),
            
            directionBottomLine.topAnchor.constraint(equalTo: directionIcon.bottomAnchor),
            directionBottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            directionBottomLine.leadingAnchor.constraint(equalTo: directionIcon.centerXAnchor),
            directionBottomLine.widthAnchor.constraint(equalToConstant: 1),
            
            busStopLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            busStopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
    internal func setupCell(item: Rest.BusRouteInfo.ItemList, isFirst: Bool, isLast: Bool) {
        guard let stationName = item.stationNm else { return }
        directionTopLine.isHidden = isFirst
        directionBottomLine.isHidden = isLast
        busStopLabel.text = stationName
        
    }
}

#Preview {
    DestinationTableViewCell()
}
