//
//  TestViewController.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/4/24.
//

import Common
import UIKit

import RxCocoa
import RxSwift

// TODO: [] 삭제 필요

final class TestViewController: BaseViewController {
    
    private weak var backgroundView: UIView!
    private weak var titleLabel: UILabel!
    private weak var subtitleLabel: UILabel!
    private weak var destinationButton: UIButton!
    private weak var destinationVC: DestinationViewController!
        
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
        titleLabel.textColor = .blueBus
        titleLabel.text = "이쯤인가"
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = .greenBus
        subtitleLabel.text = "2024.06.04"
        view.addSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        let destinationButton = UIButton()
        destinationButton.translatesAutoresizingMaskIntoConstraints = false
        destinationButton.setTitle("destination", for: .normal)
        destinationButton.setTitleColor(.black, for: .normal)
        destinationButton.isEnabled = true
        view.addSubview(destinationButton)
        self.destinationButton = destinationButton
        
        bind()
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 32)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
        
            destinationButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            destinationButton.centerXAnchor.constraint(equalTo: subtitleLabel.centerXAnchor),
            destinationButton.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            destinationButton.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func bind() {

    }
}
