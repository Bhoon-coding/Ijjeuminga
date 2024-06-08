//
//  DestinationViewController.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/06.
//

import UIKit

class DestinationViewController: BaseViewController {
    
    private weak var backgroundView: UIView!
    private weak var destinationTitle: UILabel!
    private weak var busStopTextField: UITextField!
    private weak var currentBusStopButton: UIButton!
    private weak var busStopTableView: UITableView!
    
    override func initView() {
        super.initView()

        navigationItem.title = "버스번호"
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        let destinationTitle = UILabel()
        destinationTitle.translatesAutoresizingMaskIntoConstraints = false
        destinationTitle.text = "목적지 선택"
        destinationTitle.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(destinationTitle)
        self.destinationTitle = destinationTitle
        
        let busStopTextField = UITextField()
        busStopTextField.translatesAutoresizingMaskIntoConstraints = false
        busStopTextField.placeholder = "정류장 검색"
        busStopTextField.setBaseTextField()
        view.addSubview(busStopTextField)
        self.busStopTextField = busStopTextField
        
        let currentBusStopButton = UIButton()
        currentBusStopButton.translatesAutoresizingMaskIntoConstraints = false
        currentBusStopButton.setTitle("현재 정류장", for: .normal)
        currentBusStopButton.setTitleColor(.darkGray, for: .normal)
        view.addSubview(currentBusStopButton)
        self.currentBusStopButton = currentBusStopButton
        
        let busStopTableView = UITableView()
        busStopTableView.translatesAutoresizingMaskIntoConstraints = false
        busStopTableView.delegate = self
        busStopTableView.dataSource = self
        busStopTableView.register(DestinationTableViewCell.self, forCellReuseIdentifier: "DestinationTableViewCell")
        view.addSubview(busStopTableView)
        self.busStopTableView = busStopTableView
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 16)
        
        NSLayoutConstraint.activate([
            destinationTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            destinationTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            
            busStopTextField.topAnchor.constraint(equalTo: destinationTitle.bottomAnchor, constant: 16),
            busStopTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            busStopTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            busStopTextField.heightAnchor.constraint(equalToConstant: 40),
            
            currentBusStopButton.topAnchor.constraint(equalTo: busStopTextField.bottomAnchor, constant: 16),
            currentBusStopButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            currentBusStopButton.heightAnchor.constraint(equalToConstant: 24),
            
            busStopTableView.topAnchor.constraint(equalTo: currentBusStopButton.bottomAnchor, constant: 24),
            busStopTableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            busStopTableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            busStopTableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }
}

extension DestinationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = busStopTableView.dequeueReusableCell(withIdentifier: "DestinationTableViewCell", for: indexPath) as! DestinationTableViewCell
        
        return cell
    }
}


#Preview {
    DestinationViewController()
}
