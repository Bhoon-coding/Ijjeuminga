//
//  CircleStatusBarView.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class CircleStatusBarView: BaseView {
    
    private weak var barView: UIView!
    private weak var circleView: UIView!
    
    private weak var circleLeadingConstraint: NSLayoutConstraint!
    private weak var barHeightConstraint: NSLayoutConstraint!
    private weak var barWidthConstraint: NSLayoutConstraint!
    
    struct Padding {
        private init() {}
        static let circleWidth: CGFloat = 24
    }
    
    private var statusType: BusStopStatusType = .destination {
        didSet {
            barView.backgroundColor = statusType.color
            circleView.backgroundColor = statusType.color
            switch statusType {
            case .destination, .twoStopsAgo:
                circleLeadingConstraint.constant = -(Padding.circleWidth / 2) + 1
                barWidthConstraint.constant = 0
            case .next, .previous:
                barHeightConstraint.constant = 1
                barWidthConstraint.constant = 36
                circleLeadingConstraint.constant = -1
            case .current:
                barHeightConstraint.constant = 4
                barWidthConstraint.constant = 85
                circleLeadingConstraint.constant = 1
            }
        }
    }
    
    override func initView() {
        super.initView()
        
        self.clipsToBounds = true
        
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = statusType.color
        addSubview(barView)
        self.barView = barView
        
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = statusType.color
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = Padding.circleWidth / 2
        addSubview(circleView)
        self.circleView = circleView
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor),
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleView.heightAnchor.constraint(equalToConstant: Padding.circleWidth),
            circleView.widthAnchor.constraint(equalToConstant: Padding.circleWidth),
            
            barView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            barView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        self.circleLeadingConstraint = circleView.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -1).withActive
        
        self.barHeightConstraint = barView.heightAnchor.constraint(equalToConstant: 1).withActive
        
        self.barWidthConstraint = barView.widthAnchor.constraint(equalToConstant: 100).withActive
    }
    
    func configure(statusType: BusStopStatusType) {
        self.statusType = statusType
    }
}
