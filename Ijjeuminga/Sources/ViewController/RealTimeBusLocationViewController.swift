//
//  RealTimeBusLocationViewController.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RealTimeBusLocationViewController: 
    ViewModelInjectionBaseViewController<RealTimeBusLocationViewModel, RealTimeBusLocationViewModelOutput> {
    
    private weak var titleLabel: UILabel!
    private weak var guideView: UIView!
    private weak var guideLabel: UILabel!
    private weak var tableView: UITableView!
    private weak var closeButton: UIButton!
    private weak var stackView: UIStackView!
    private weak var timeCountView: TimeCountView!
    private var dataList: [Int] = []
    
    override func initView() {
        super.initView()
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = viewModel.busColor
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.titleLabel = titleLabel
        navigationItem.titleView = titleLabel
        
        let guideView = UIView()
        guideView.translatesAutoresizingMaskIntoConstraints = false
        guideView.backgroundColor = .containerBackground
        guideView.clipsToBounds = true
        guideView.layer.cornerRadius = 8
        self.guideView = guideView
        
        let guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.font = UIFont(name: Font.sandollGothicBold, size: 16)
        guideLabel.textColor = .noticeText
        guideLabel.textAlignment = .center
        guideLabel.text = "Tip. 목적지 도착에 맞춰 음성 안내 및 휴대폰 진동으로 알려드립니다."
        guideLabel.numberOfLines = 0
        guideLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        guideView.addSubview(guideLabel)
        self.guideLabel = guideLabel
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(BusStopStatusTableViewCell.self,
                           forCellReuseIdentifier: BusStopStatusTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.tableView = tableView
        
        var config = UIButton.Configuration.plain()
        var title = AttributedString("안내 종료")
        title.font = UIFont(name: Font.sandollGothicBold, size: 16)
        title.foregroundColor = .redBus
        config.attributedTitle = title
        config.titleAlignment = .center
        config.contentInsets = .init(top: 16, leading: 32, bottom: 16, trailing: 32)
        let closeButton = UIButton(configuration: config)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = 24
        closeButton.layer.borderWidth = 1
        closeButton.tintColor = .redBus
        closeButton.layer.borderColor = UIColor.redBus.cgColor
        self.closeButton = closeButton
        
        let stackView = UIStackView(arrangedSubviews: [guideView, tableView, closeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .center
        view.addSubview(stackView)
        self.stackView = stackView
        
        let timeCountView = TimeCountView()
        timeCountView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeCountView)
        self.timeCountView = timeCountView
        
        initEvent()
    }

    override func initConstraint() {
        super.initConstraint()
        
        stackView.setConstraintsToMatch(view, top: 16)
        guideLabel.setConstraintsToMatch(guideView, top: 8, leading: 12, trailing: 12, bottom: 8)
        
        NSLayoutConstraint.activate([
            guideView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            guideView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            
            tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            
            timeCountView.widthAnchor.constraint(equalToConstant: TimeCountView.Padding.width),
            timeCountView.heightAnchor.constraint(equalToConstant: TimeCountView.Padding.width),
            timeCountView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: -48),
            timeCountView.trailingAnchor.constraint(equalTo: guideLabel.trailingAnchor)
        ])
    }
    
    private func initEvent() {
        viewModel.dataSource.bind(tableView)
        tableView.rx.setDelegate(viewModel.dataSource)
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                let closePopup = CustomAlertController()
                    .setTitleMessage("안내를 종료할까요?")
                    .addaction("취소", .cancel)
                    .addaction("종료", .default) { [weak self] _ in
                        self?.viewModel.output.close.onNext(())
                    }
                    .setPreferredAction(action: .default)
                    .build()
                
                self?.present(closePopup, animated: true)
            }
            .disposed(by: disposeBag)
        
        timeCountView.output.didTap
            .bind(to: viewModel.input.updateBusLocation)
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        super.bind()
        
        viewModel.output.busNumber
            .observe(on: MainScheduler.instance)
            .bind(to: titleLabel.rx.text)
            .disposed(by: viewDisposeBag)

        viewModel.output.startTimer
            .subscribe { [weak timeCountView] time in
                timeCountView?.input.startTimer.onNext(time)
            }
            .disposed(by: viewDisposeBag)
        
        viewModel.output.stopTimer
            .subscribe { [weak timeCountView] _ in
                timeCountView?.input.stopTimer.onNext(())
            }
            .disposed(by: viewDisposeBag)
        
        viewModel.output.enableButton
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak closeButton, weak timeCountView] enable in
                let color = UIColor.redBus.withAlphaComponent(enable ? 1 : 0.5)
                var modified = closeButton?.configuration
                modified?.attributedTitle?.foregroundColor = color
                closeButton?.configuration = modified
                closeButton?.layer.borderColor = color.cgColor
                closeButton?.isUserInteractionEnabled = enable
                timeCountView?.alpha = enable ? 1 : 0.5
                timeCountView?.isUserInteractionEnabled = enable
            })
            .disposed(by: viewDisposeBag)
    }
}
