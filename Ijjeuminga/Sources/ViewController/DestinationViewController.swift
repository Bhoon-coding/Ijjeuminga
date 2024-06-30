//
//  DestinationViewController.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/06.
//

import UIKit

import RxSwift

class DestinationViewController: BaseViewController {
    
    private weak var backgroundView: UIView!
    private weak var destinationTitle: UILabel!
    private weak var busStopTextField: UITextField!
    private weak var currentBusStopButton: UIButton!
    private weak var busStopTableView: UITableView!
    
    private var stationRouteSubject = PublishSubject<[Rest.BusRouteInfo.ItemList]>()
    private var stationRouteItemList: [Rest.BusRouteInfo.ItemList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        fetchStaionByRoute()
    }
    
    private func bind() {
        stationRouteSubject.bind(onNext: { [weak self] itemList in
            guard let self = self else { return }
            self.stationRouteItemList = itemList
            DispatchQueue.main.async {
                self.busStopTableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchStaionByRoute() {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: "100100124")
            .subscribe { [weak self] res in
                guard let self = self else { return }
                guard let resStationRoute = res.msgBody.itemList else { return }
                self.stationRouteSubject.onNext(resStationRoute)

            } onFailure: { error in
                print("error: \(error)")

            }
            .disposed(by: disposeBag)
    }
    
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
        busStopTextField.delegate = self
        view.addSubview(busStopTextField)
        self.busStopTextField = busStopTextField
        
        let currentBusStopButton = UIButton()
        currentBusStopButton.translatesAutoresizingMaskIntoConstraints = false
        currentBusStopButton.setTitle("현재 정류장", for: .normal)
        // TODO: [] image, contents padding 주기
        currentBusStopButton.setTitleColor(UIColor(resource: .busStopText), for: .normal)
        currentBusStopButton.setImage(.add, for: .normal)
        view.addSubview(currentBusStopButton)
        self.currentBusStopButton = currentBusStopButton
        
        let busStopTableView = UITableView()
        busStopTableView.translatesAutoresizingMaskIntoConstraints = false
        busStopTableView.delegate = self
        busStopTableView.dataSource = self
        busStopTableView.register(DestinationTableViewCell.self, forCellReuseIdentifier: DestinationTableViewCell.identifier)
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
        return self.stationRouteItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = busStopTableView.dequeueReusableCell(
            withIdentifier: DestinationTableViewCell.identifier,
            for: indexPath
        ) as? DestinationTableViewCell else {
            return UITableViewCell()
        }
        
        let stationRoute = stationRouteItemList[indexPath.row]
        
        cell.setupCell(item: stationRoute)
        return cell
    }
}

extension DestinationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        busStopTextField.resignFirstResponder()
        return true
    }
}
