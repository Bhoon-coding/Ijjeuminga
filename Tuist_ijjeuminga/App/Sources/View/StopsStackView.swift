//
//  StopsStackView.swift
//  Ijjeuminga
//
//  Created by BH on 9/23/24.
//

import Common
import UIKit.UIView

final class StopsStackView: UIStackView {
    
    private weak var iconImageView: UIImageView!
    private weak var stationLabel: UILabel!
    private weak var divider: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
//        initView()
//        initConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStopItem(stationName: String, showDivider: Bool) {
        let stopView = UIView()
        stopView.translatesAutoresizingMaskIntoConstraints = false
        stopView.backgroundColor = .clear
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = CommonAsset.Directions.red.image // TODO: [] 색상변경
        stopView.addSubview(iconImageView)
        self.iconImageView = iconImageView
        
        let stationLabel = UILabel()
        stationLabel.translatesAutoresizingMaskIntoConstraints = false
        stationLabel.text = stationName
        stationLabel.textColor = .busStopText
        stationLabel.font = .bold(8)
        stopView.addSubview(stationLabel)
        self.stationLabel = stationLabel
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: stopView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: stopView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 8),
            iconImageView.heightAnchor.constraint(equalToConstant: 8),
            
            stationLabel.trailingAnchor.constraint(equalTo: stopView.trailingAnchor),
            stationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            stationLabel.centerYAnchor.constraint(equalTo: stopView.centerYAnchor)
        ])
        
        if showDivider {
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = .grayF4F4F4
            stopView.addSubview(divider)
            
            NSLayoutConstraint.activate([
                divider.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
                divider.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 2),
                divider.widthAnchor.constraint(equalToConstant: 1),
                divider.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
        
        self.addArrangedSubview(stopView)
    }
}

#Preview {
    StopsStackView(frame: .zero)
}
