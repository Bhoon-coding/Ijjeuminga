//
//  BusStopStatusTableViewCell.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BusStopStatusTableViewCell: BaseTableViewCell<RealTimeBusLocationData> {
    
    static let id = "BusStopStatusTableViewCell"
    
    private weak var circleBarView: CircleStatusBarView!
    private weak var circleBarBottomSpacer: UIView!
    private weak var titleLabel: UILabel!
    private weak var nameLabel: UILabel!
    private weak var textBottomSpacer: UIView!
    
    override func initView() {
        super.initView()
        
        let circleBarView = CircleStatusBarView()
        circleBarView.translatesAutoresizingMaskIntoConstraints = false
        circleBarView.configure(statusType: .current)
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
        textStackView.alignment = .fill
        textStackView.distribution = .equalSpacing
        
        let textContainerStackView = UIStackView(arrangedSubviews: [textStackView, textBottomSpacer])
        textContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        textContainerStackView.axis = .vertical
        textContainerStackView.alignment = .fill
        textContainerStackView.distribution = .fill
        
        let circleBarBottomSpacer = UIView()
        circleBarBottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        self.circleBarBottomSpacer = circleBarBottomSpacer
        
        let circleStackView = UIStackView(arrangedSubviews: [circleBarView, circleBarBottomSpacer])
        circleStackView.translatesAutoresizingMaskIntoConstraints = false
        circleStackView.axis = .vertical
        circleStackView.spacing = 0
        circleStackView.alignment = .fill
        circleStackView.distribution = .equalSpacing
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        let totalStackView = UIStackView(arrangedSubviews: [circleStackView, textContainerStackView, spacer])
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.axis = .horizontal
        totalStackView.spacing = 16
        totalStackView.alignment = .bottom
        totalStackView.distribution = .fillProportionally
        contentView.addSubview(totalStackView)
        totalStackView.setConstraintsToMatch(contentView, top: 32, bottom: 32)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: totalStackView.topAnchor),
            circleBarBottomSpacer.heightAnchor.constraint(equalToConstant: 4),
            textBottomSpacer.heightAnchor.constraint(equalToConstant: 2),
            spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])
    }

    override func configureCell(data: RealTimeBusLocationData?) {
        super.configureCell(data: data)
        
        guard let data = data else {
            return
        }
        
        nameLabel.text = data.name
        nameLabel.textColor = data.type.color
        nameLabel.font = data.type.font
        titleLabel.text = data.type.title
        titleLabel.isHidden = data.type.title.isEmpty
        titleLabel.font = data.type.titleFont
        circleBarView.configure(statusType: data.type)
        circleBarBottomSpacer.isHidden = data.type != .current
        textBottomSpacer.isHidden = data.type != .next
    }
}
