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
        
        initView()
        initConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = CommonAsset.Directions.red.image // TODO: [] 색상변경
        self.addArrangedSubview(iconImageView)
        self.iconImageView = iconImageView
        
        let stationLabel = UILabel()
        stationLabel.translatesAutoresizingMaskIntoConstraints = false
        stationLabel.text = "정보없음"
        stationLabel.textColor = .busStopText
        stationLabel.font = .bold(8)
        self.addArrangedSubview(stationLabel)
        self.stationLabel = stationLabel
    }
    
    private func initConstraint() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            stationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            stationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

#Preview {
    StopsStackView(frame: .zero)
}
