//
//  DestinationTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import Common
import UIKit.UITableViewCell

import SkeletonView

final class DestinationTableViewCell: BaseTableViewCell<(DestinationTableData, Int)> {
    
    static let identifier: String = "DestinationTableViewCell"
    
    private weak var busStationLabel: UILabel!
    private weak var directionImageView: UIImageView!
    private weak var directionTopLine: UIView!
    private weak var directionBottomLine: UIView!
    private weak var currentPositionImageView: UIImageView!
    
    override func initView() {
        super.initView()
        
        self.isSkeletonable = true
        
        let directionIcon = UIImageView()
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.isSkeletonable = true
        directionIcon.image = Assets.Directions.red.image
        contentView.addSubview(directionIcon)
        self.directionImageView = directionIcon
        
        let currentPositionIcon = UIImageView()
        currentPositionIcon.translatesAutoresizingMaskIntoConstraints = false
        currentPositionIcon.isSkeletonable = true
        currentPositionIcon.image = Assets.Positions.greenIcon.image
        currentPositionIcon.layer.zPosition = 1
        contentView.addSubview(currentPositionIcon)
        self.currentPositionImageView = currentPositionIcon
        
        let directionTopLine = UIView()
        directionTopLine.translatesAutoresizingMaskIntoConstraints = false
        directionTopLine.isSkeletonable = true
        directionTopLine.backgroundColor = .redBus
        contentView.addSubview(directionTopLine)
        self.directionTopLine = directionTopLine
        
        let directionBottomLine = UIView()
        directionBottomLine.translatesAutoresizingMaskIntoConstraints = false
        directionBottomLine.isSkeletonable = true
        directionBottomLine.backgroundColor = .redBus
        contentView.addSubview(directionBottomLine)
        self.directionBottomLine = directionBottomLine
        
        let busStationLabel = UILabel()
        busStationLabel.translatesAutoresizingMaskIntoConstraints = false
        busStationLabel.isSkeletonable = true
        busStationLabel.text = "강남역"
        busStationLabel.textColor = .busStopText
        busStationLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(busStationLabel)
        self.busStationLabel = busStationLabel
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            directionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            directionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            directionImageView.widthAnchor.constraint(equalToConstant: 16),
            directionImageView.heightAnchor.constraint(equalToConstant: 16),
            
            currentPositionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentPositionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currentPositionImageView.widthAnchor.constraint(equalToConstant: 32),
            currentPositionImageView.heightAnchor.constraint(equalToConstant: 32),
            
            directionTopLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            directionTopLine.bottomAnchor.constraint(equalTo: directionImageView.topAnchor),
            directionTopLine.leadingAnchor.constraint(equalTo: directionImageView.centerXAnchor),
            directionTopLine.widthAnchor.constraint(equalToConstant: 1),
            
            directionBottomLine.topAnchor.constraint(equalTo: directionImageView.bottomAnchor),
            directionBottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            directionBottomLine.leadingAnchor.constraint(equalTo: directionImageView.centerXAnchor),
            directionBottomLine.widthAnchor.constraint(equalToConstant: 1),
            
            busStationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStationLabel.leadingAnchor.constraint(equalTo: directionImageView.trailingAnchor, constant: 32),
            busStationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
    override func configureCell(data: (DestinationTableData, Int)?) {
        guard let (data, index) = data else { return }
        
        switch data {
        case .searchResult:
            break
        case .stationResult(let station, let isLast, let nearestIndex, let busType):
            setColor(with: busType)
            directionTopLine.isHidden = index == 0
            directionBottomLine.isHidden = isLast
            busStationLabel.text = station.stationNm
            currentPositionImageView.isHidden = index != nearestIndex
            directionImageView.isHidden = index == nearestIndex
        }
    }
    
    private func setColor(with busType: KoreaBusType.RawValue) {
        directionTopLine.backgroundColor = KoreaBusType(rawValue: busType)?.colors.color
        directionBottomLine.backgroundColor = KoreaBusType(rawValue: busType)?.colors.color
        directionImageView.image = KoreaBusType(rawValue: busType)?.directionImage.image
        currentPositionImageView.image = KoreaBusType(rawValue: busType)?.positionImage.image
    }
}

#Preview {
    DestinationTableViewCell()
}
