//
//  BusStationSelectView.swift
//  Ijjeuminga
//
//  Created by BH on 9/24/24.
//

import Common
import UIKit.UIView

class BusStationSelectView: BaseView {
    
    private weak var stopView: UIView!
    private weak var iconImageView: UIImageView!
    private weak var currentStationLabel: UILabel!
    private weak var divider: UIView!
    private weak var stopsStackView: StopsStackView!
    
    override func initView() {
        super.initView()
        
        let stopView = UIView()
        stopView.translatesAutoresizingMaskIntoConstraints = false
        stopView.backgroundColor = .blueBus
        self.addSubview(stopView)
        self.stopView = stopView
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = CommonAsset.Directions.red.image // TODO: [] 색상변경 필요
        self.addSubview(iconImageView)
        self.iconImageView = iconImageView
        
        let currentStationLabel = UILabel()
        currentStationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStationLabel.text = "마전지구버스차고지" // TODO: [] 현재 정류장 표기
        currentStationLabel.textColor = .busStopText
        currentStationLabel.font = .bold(16)
        self.addSubview(currentStationLabel)
        self.currentStationLabel = currentStationLabel
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .grayF4F4F4
        self.addSubview(divider)
        self.divider = divider
        
        let stopsStackView = StopsStackView()
        stopsStackView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: [] arrangeSubView 필요 (다음 방면 정류장 3개 표시 필요)
        stopsStackView.axis = .vertical
        stopsStackView.distribution = .equalSpacing
        stopsStackView.alignment = .leading
        // TODO: [] 반복문 돌리기
        stopsStackView.addStopItem(stationName: "마전지구버스차고지", showDivider: true)
        stopsStackView.addStopItem(stationName: "마포역", showDivider: true)
        stopsStackView.addStopItem(stationName: "종점", showDivider: false)
        self.addSubview(stopsStackView)
        self.stopsStackView = stopsStackView
        
        initConstraint()
    }
    
    private func initConstraint() {
        NSLayoutConstraint.activate([
            stopView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stopView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stopView.heightAnchor.constraint(equalToConstant: 16),
            
            iconImageView.centerYAnchor.constraint(equalTo: stopView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: stopView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            currentStationLabel.centerYAnchor.constraint(equalTo: stopView.centerYAnchor),
            currentStationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            divider.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            stopsStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            stopsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stopsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            stopsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
        ])
    }
    
}
