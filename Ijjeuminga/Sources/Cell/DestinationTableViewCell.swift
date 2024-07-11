//
//  DestinationTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import UIKit

final class DestinationTableViewCell: BaseTableViewCell<(DestinationTableData, Int)> {
    
    static let identifier: String = "DestinationTableViewCell"
    
    private weak var busStationLabel: UILabel!
    private weak var directionIcon: UIImageView!
    private weak var directionTopLine: UIView!
    private weak var directionBottomLine: UIView!
    private weak var currentPositionIcon: UIImageView!

    override func initView() {
        super.initView()
        
        let directionIcon = UIImageView()
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.image = .directionIcon
        contentView.addSubview(directionIcon)
        self.directionIcon = directionIcon
        
        let currentPositionIcon = UIImageView()
        currentPositionIcon.translatesAutoresizingMaskIntoConstraints = false
        currentPositionIcon.image = .currentPositionIcon
        currentPositionIcon.layer.zPosition = 1
        contentView.addSubview(currentPositionIcon)
        self.currentPositionIcon = currentPositionIcon
        
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
        
        let busStationLabel = UILabel()
        busStationLabel.translatesAutoresizingMaskIntoConstraints = false
        busStationLabel.text = "강남역"
        busStationLabel.textColor = .busStopText
        busStationLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(busStationLabel)
        self.busStationLabel = busStationLabel
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            directionIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            directionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            directionIcon.widthAnchor.constraint(equalToConstant: 16),
            directionIcon.heightAnchor.constraint(equalToConstant: 16),
            
            currentPositionIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentPositionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currentPositionIcon.widthAnchor.constraint(equalToConstant: 32),
            currentPositionIcon.heightAnchor.constraint(equalToConstant: 32),
            
            directionTopLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            directionTopLine.bottomAnchor.constraint(equalTo: directionIcon.topAnchor),
            directionTopLine.leadingAnchor.constraint(equalTo: directionIcon.centerXAnchor),
            directionTopLine.widthAnchor.constraint(equalToConstant: 1),
            
            directionBottomLine.topAnchor.constraint(equalTo: directionIcon.bottomAnchor),
            directionBottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            directionBottomLine.leadingAnchor.constraint(equalTo: directionIcon.centerXAnchor),
            directionBottomLine.widthAnchor.constraint(equalToConstant: 1),
            
            busStationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStationLabel.leadingAnchor.constraint(equalTo: directionIcon.trailingAnchor, constant: 32),
            busStationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
    override func configureCell(data: (DestinationTableData, Int)?) {
        // MARK: - super 안해도 되는지?
        guard let (data, index) = data else { return }
        
        switch data {
        case .searchResult:
            break
        case .stationResult(let station, let isLast, let nearestIndex):
            directionTopLine.isHidden = index == 0
            directionBottomLine.isHidden = isLast
            busStationLabel.text = station.stationNm
            currentPositionIcon.isHidden = index != nearestIndex
            directionIcon.isHidden = index == nearestIndex
        }
    }
}

#Preview {
    DestinationTableViewCell()
}
