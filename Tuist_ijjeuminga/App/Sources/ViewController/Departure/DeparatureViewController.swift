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

class DeparatureViewController: ViewModelInjectionBaseViewController<DepartureViewModel, DepartureViewModelOutput> {
    
    private weak var titleLabel: UILabel!
    private weak var backgroundView: UIView!
    private weak var departureTitle: UILabel!
    private weak var departureSubtitle: UILabel!
    private weak var firstSelectView: BusStationSelectView!
    private weak var secondSelectView: BusStationSelectView!
    private weak var confirmButton: UIButton!
    
    override func bind() {
        super.bind()

        self.viewModel.output.busNumber
            .bind(to: titleLabel.rx.text)
            .disposed(by: viewDisposeBag)
    }

    override func initView() {
        super.initView()
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = KoreaBusType(rawValue: viewModel.busType)?.colors.color
        titleLabel.font = .bold(16)
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
     
        let firstSelectView = BusStationSelectView()
        firstSelectView.translatesAutoresizingMaskIntoConstraints = false
        firstSelectView.layer.cornerRadius = 16
        firstSelectView.layer.borderColor = UIColor.primaryToryBlue.cgColor
        firstSelectView.layer.borderWidth = 2
        backgroundView.addSubview(firstSelectView)
        self.firstSelectView = firstSelectView
        
        let secondSelectView = BusStationSelectView()
        secondSelectView.translatesAutoresizingMaskIntoConstraints = false
        secondSelectView.layer.cornerRadius = 16
        secondSelectView.layer.borderColor = UIColor.containerBackground.cgColor
        secondSelectView.layer.borderWidth = 2
        backgroundView.addSubview(secondSelectView)
        self.secondSelectView = secondSelectView
        
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 8
        confirmButton.backgroundColor = .primaryToryBlue
        confirmButton.setTitle("선택완료", for: .normal)
        confirmButton.titleLabel?.font = .bold(16)
        backgroundView.addSubview(confirmButton)
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
            
            firstSelectView.topAnchor.constraint(equalTo: departureSubtitle.bottomAnchor, constant: 32),
            firstSelectView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            firstSelectView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            firstSelectView.heightAnchor.constraint(equalToConstant: 160),
            
            secondSelectView.topAnchor.constraint(equalTo: firstSelectView.bottomAnchor, constant: 24),
            secondSelectView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            secondSelectView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            secondSelectView.heightAnchor.constraint(equalToConstant: 160),
            
            confirmButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8),
            confirmButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
            confirmButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            confirmButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
}


#Preview {
    DeparatureViewController(viewModel: DepartureViewModel(routeId: "100100139", busType: 1))
}
