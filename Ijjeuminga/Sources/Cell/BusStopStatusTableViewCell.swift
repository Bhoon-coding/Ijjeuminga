//
//  BusStopStatusTableViewCell.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BusStopStatusTableViewCell: BaseTableViewCell<(RealTimeBusLocationData, Int)> {
    
    static let id = "BusStopStatusTableViewCell"
    
    private weak var circleBarView: CircleStatusBarView!
    private weak var circleBarBottomSpacer: UIView!
    private weak var titleLabel: UILabel!
    private weak var nameLabel: UILabel!
    private weak var textBottomSpacer: UIView!
    private weak var textStackView: UIStackView!
    private weak var spacer: UIView!
    private weak var totalStackView: UIStackView!
    
    override func initView() {
        super.initView()
        
        let circleBarView = CircleStatusBarView()
        circleBarView.translatesAutoresizingMaskIntoConstraints = false
        circleBarView.configure(statusType: .current, positionType: .middle)
        self.circleBarView = circleBarView
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        self.titleLabel = titleLabel
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel = nameLabel
        
        let textBottomSpacer = UIView()
        textBottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        self.textBottomSpacer = textBottomSpacer
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, nameLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.spacing = 10
        textStackView.distribution = .equalSpacing
        self.textStackView = textStackView
        
        let textContainerStackView = UIStackView(arrangedSubviews: [textStackView, textBottomSpacer])
        textContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        textContainerStackView.axis = .vertical
        
        let circleBarBottomSpacer = UIView()
        circleBarBottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        self.circleBarBottomSpacer = circleBarBottomSpacer
        
        let circleStackView = UIStackView(arrangedSubviews: [circleBarView, circleBarBottomSpacer])
        circleStackView.translatesAutoresizingMaskIntoConstraints = false
        circleStackView.axis = .vertical
        circleStackView.distribution = .equalSpacing
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.spacer = spacer
        
        let totalStackView = UIStackView(arrangedSubviews: [circleStackView, textContainerStackView, spacer])
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.axis = .horizontal
        totalStackView.spacing = 16
        totalStackView.alignment = .bottom
        totalStackView.distribution = .fillProportionally
        self.totalStackView = totalStackView
        
        contentView.addSubview(totalStackView)
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        totalStackView.setConstraintsToMatch(contentView, top: 32, bottom: 32)
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: totalStackView.topAnchor),
            circleBarBottomSpacer.heightAnchor.constraint(equalToConstant: 4),
            textBottomSpacer.heightAnchor.constraint(equalToConstant: 2),
            spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])
    }

    override func configureCell(data: (RealTimeBusLocationData, Int)?) {
        super.configureCell(data: data)
        
        guard let (data, index) = data,
              let position = BusStopPositionType(rawValue: index) else {
            return
        }

        circleBarView.configure(statusType: data.type, positionType: position)
        circleBarBottomSpacer.isHidden = position != .middle
        textBottomSpacer.isHidden = position != .topMiddle
        nameLabel.text = data.name
        nameLabel.textColor = data.type.color
        nameLabel.font = data.isEmpty ? BusStopPositionType.topMiddle.font : position.font
        titleLabel.text = position.title
        titleLabel.isHidden = position.title.isEmpty || data.isEmpty
        titleLabel.font = position.titleFont
    }
}
