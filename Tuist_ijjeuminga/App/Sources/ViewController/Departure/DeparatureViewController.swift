//
//  DeparatureViewController.swift
//  Common
//
//  Created by BH on 9/23/24.
//

import Common
import UIKit

import RxSwift
import RxCocoa

class DeparatureViewController: ViewModelInjectionBaseViewController<DeparatureViewModel, DepartureViewModelOutput> {
    
    private weak var titleLabel: UILabel!
    private weak var backgroundView: UIView!
    private weak var departureTitle: UILabel!
    private weak var departureSubtitle: UILabel!
    private weak var containerView: UIView!
    private weak var iconImageView: UIImageView!
    private weak var currentStationLabel: UILabel!
    private weak var divider: UIView!
    private weak var stopsStackView: UIStackView!
    private weak var confirmButton: UIButton!

    override func initView() {
        super.initView()
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = KoreaBusType(rawValue: viewModel.busType)?.colors.color
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.titleLabel = titleLabel
        navigationItem.titleView = titleLabel
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        let departureTitle = UILabel()
        departureTitle.translatesAutoresizingMaskIntoConstraints = false
        departureTitle.text = "출발지 선택."
        departureTitle.font = .bold(24)
        backgroundView.addSubview(departureTitle)
        self.departureTitle = departureTitle
        
        let departureSubtitle = UILabel()
        departureSubtitle.translatesAutoresizingMaskIntoConstraints = false
        departureSubtitle.text = "현재 정류장을 선택해주세요"
        departureSubtitle.font = .bold(16)
        departureSubtitle.textColor = .busStopText
        backgroundView.addSubview(departureSubtitle)
        self.departureSubtitle = departureSubtitle
     
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: [] 선택됨에 따라 색상 border 색상 변경
        containerView.layer.cornerRadius = 16
        backgroundView.addSubview(containerView)
        self.containerView = containerView
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = CommonAsset.Directions.red.image // TODO: [] 색상변경 필요
        containerView.addSubview(iconImageView)
        self.iconImageView = iconImageView
        
        let currentStationLabel = UILabel()
        currentStationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStationLabel.text = "마전지구버스차고지" // TODO: [] 현재 정류장 표기
        currentStationLabel.textColor = .busStopText
        currentStationLabel.font = .bold(16)
        containerView.addSubview(currentStationLabel)
        self.currentStationLabel = currentStationLabel
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .grayF4F4F4
        containerView.addSubview(divider)
        self.divider = divider
        
        let stopsStackView = UIStackView()
        stopsStackView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: [] arrangeSubView 필요 (다음 방면 정류장 3개 표시 필요)
        containerView.backgroundColor = .clear
        containerView.addSubview(stopsStackView)
        self.stopsStackView = stopsStackView
        
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 8
        confirmButton.backgroundColor = .primaryToryBlue
        confirmButton.setTitle("선택완료", for: .normal)
        confirmButton.titleLabel?.font = .bold(16)
        containerView.addSubview(confirmButton)
        self.confirmButton = confirmButton
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 16)
        
        NSLayoutConstraint.activate([
            departureTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            departureTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            
            departureSubtitle.topAnchor.constraint(equalTo: departureTitle.bottomAnchor, constant: 8),
            departureSubtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            
            containerView.topAnchor.constraint(equalTo: departureSubtitle.bottomAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 160),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            currentStationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            currentStationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            divider.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            stopsStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            stopsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stopsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            stopsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            
            confirmButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8),
            confirmButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
            confirmButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            confirmButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
}


#Preview {
    DeparatureViewController(viewModel: DeparatureViewModel(routeId: "100100139", busType: 1))
}
