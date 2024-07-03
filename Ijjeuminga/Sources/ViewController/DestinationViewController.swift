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
    private weak var currentStationStackView: UIStackView!
    private weak var currentStationImageView: UIImageView!
    private weak var currentStationLabel: UILabel!
    private weak var busStopTableView: UITableView!
    
    private var stationRouteSubject = PublishSubject<[Rest.BusRouteInfo.ItemList]>()
    private var stationRouteItemList: [Rest.BusRouteInfo.ItemList] = []
    private let locationDataManager = LocationDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStationByRoute()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationDataManager.requestLocationAuth()
    }
    
    private func fetchStationByRoute() {
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
    
    private func bind() {
        stationRouteSubject.bind(onNext: { [weak self] itemList in
            guard let self = self else { return }
            self.stationRouteItemList = itemList
            locationDataManager.stations = self.stationRouteItemList
            DispatchQueue.main.async {
                self.busStopTableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }
    
    @objc 
    private func tapCurrentStation() {
        let nearestStationIndex: Int = locationDataManager.nearestStationIndex
        
        busStopTableView.scrollToRow(
            at: IndexPath(row: nearestStationIndex, section: 0),
            at: .middle,
            animated: true
        )
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
        
        let currentStationTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentStation))
        
        let currentStationStackView = UIStackView()
        currentStationStackView.translatesAutoresizingMaskIntoConstraints = false
        currentStationStackView.spacing = 4
        currentStationStackView.addGestureRecognizer(currentStationTapGesture)
        view.addSubview(currentStationStackView)
        self.currentStationStackView = currentStationStackView
        
        let currentStationImageView = UIImageView()
        currentStationImageView.translatesAutoresizingMaskIntoConstraints = false
        currentStationImageView.image = .targetIcon
        currentStationStackView.addArrangedSubview(currentStationImageView)
        self.currentStationImageView = currentStationImageView
        
        let currentStationLabel = UILabel()
        currentStationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStationLabel.text = "현재 정류장"
        currentStationLabel.font = .boldSystemFont(ofSize: 16)
        currentStationLabel.textColor = .busStopText
        currentStationStackView.addArrangedSubview(currentStationLabel)
        self.currentStationLabel = currentStationLabel
        
        let busStopTableView = UITableView()
        busStopTableView.translatesAutoresizingMaskIntoConstraints = false
        busStopTableView.delegate = self
        busStopTableView.dataSource = self
        busStopTableView.register(
            DestinationTableViewCell.self,
            forCellReuseIdentifier: DestinationTableViewCell.identifier
        )
        busStopTableView.rowHeight = 54
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
            
            currentStationStackView.topAnchor.constraint(equalTo: busStopTextField.bottomAnchor, constant: 16),
            currentStationStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            currentStationStackView.heightAnchor.constraint(equalToConstant: 16),
            
            currentStationImageView.widthAnchor.constraint(equalToConstant: 16),
            currentStationImageView.heightAnchor.constraint(equalToConstant: 16),
            
            busStopTableView.topAnchor.constraint(equalTo: currentStationStackView.bottomAnchor, constant: 24),
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
        let isLast = stationRouteItemList.endIndex - 1 == indexPath.row
        cell.setupCell(
            item: stationRoute,
            isLast: isLast,
            indexPath: indexPath,
            nearestStationIndex: locationDataManager.nearestStationIndex
        )
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

#Preview {
    DestinationViewController()
}
