//
//  TestViewController.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TestViewController: BaseViewController {
    
    private weak var backgroundView: UIView!
    private weak var titleLabel: UILabel!
    private weak var subtitleLabel: UILabel!
    private weak var moveButton: UIButton!
    
    override func initView() {
        super.initView()
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .yellow
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 16
        view.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .blue
        titleLabel.text = "이쯤인가"
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = UIColor(resource: .greenBus)
        subtitleLabel.text = "2024.06.04"
        view.addSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        let moveButton = UIButton()
        moveButton.translatesAutoresizingMaskIntoConstraints = false
        moveButton.setTitle("move!", for: .normal)
        moveButton.setTitleColor(.black, for: .normal)
        moveButton.isEnabled = true
        view.addSubview(moveButton)
        self.moveButton = moveButton
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 32)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            moveButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            moveButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            moveButton.heightAnchor.constraint(equalToConstant: 40),
            moveButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moveButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.backgroundView.backgroundColor = .green
                let controller = TestViewController()
                controller.view.backgroundColor = .black
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: viewDisposeBag)
        
        BusPositionAPIService()
            .getBusPosition(with: "100100124") // BusRouteId
            .subscribe { [weak self] response in
                print("================ LOG ================")
                print("||")
                print("||", self!)
                print("||", #function)
                print("||", "message: \(response)")
                print("||")
                print("=====================================")

            } onFailure: { error in
                print("================ LOG ================")
                print("||")
                print("||", self)
                print("||", #function)
                print("||", "error message: \(error)")
                print("||")
                print("=====================================")

            }
            .disposed(by: disposeBag)

    }
}
