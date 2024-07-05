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
    private weak var busStationSearchBar: UISearchBar!
    private weak var currentStationStackView: UIStackView!
    private weak var currentStationImageView: UIImageView!
    private weak var currentStationLabel: UILabel!
    private weak var busStationTableView: UITableView!
    
    private var stationRouteSubject = PublishSubject<[Rest.BusRouteInfo.ItemList]>()
    private var stationRouteItemList: [Rest.BusRouteInfo.ItemList] = []
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    private var isSearched: Bool = false {
        didSet {
            configureTableView()
            currentStationStackView.isHidden = isSearched
        }
    }
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
    
    private func configureTableView() {
        isSearched
        ? self.busStationTableView.register(
            DestinationSearchedTableViewCell.self,
            forCellReuseIdentifier: DestinationSearchedTableViewCell.identifier
        )
        : self.busStationTableView.register(
            DestinationTableViewCell.self,
            forCellReuseIdentifier: DestinationTableViewCell.identifier
        )
        
        DispatchQueue.main.async {
            self.busStationTableView.reloadData()
        }
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
            configureTableView()
        })
        .disposed(by: disposeBag)
    }
    
    @objc 
    private func tapCurrentStation() {
        let nearestStationIndex: Int = locationDataManager.nearestStationIndex
        
        busStationTableView.scrollToRow(
            at: IndexPath(row: nearestStationIndex, section: 0),
            at: .middle,
            animated: true
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
        let busStationSearchBar = UISearchBar()
        busStationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        busStationSearchBar.placeholder = "정류장 검색"
        busStationSearchBar.backgroundImage = UIImage()
        busStationSearchBar.delegate = self
        view.addSubview(busStationSearchBar)
        self.busStationSearchBar = busStationSearchBar
        
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
        
        let busStationTableView = UITableView()
        busStationTableView.translatesAutoresizingMaskIntoConstraints = false
        busStationTableView.delegate = self
        busStationTableView.dataSource = self
        busStationTableView.rowHeight = 54
        busStationTableView.showsVerticalScrollIndicator = false
        busStationTableView.register(
            DestinationTableViewCell.self,
            forCellReuseIdentifier: DestinationTableViewCell.identifier
        )
        view.addSubview(busStationTableView)
        self.busStationTableView = busStationTableView
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 16)
        
        NSLayoutConstraint.activate([
            destinationTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            destinationTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            
            busStationSearchBar.topAnchor.constraint(equalTo: destinationTitle.bottomAnchor, constant: 16),
            busStationSearchBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            busStationSearchBar.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            busStationSearchBar.heightAnchor.constraint(equalToConstant: 40),
            
            currentStationStackView.topAnchor.constraint(equalTo: busStationSearchBar.bottomAnchor, constant: 16),
            currentStationStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            currentStationStackView.heightAnchor.constraint(equalToConstant: 16),
            
            currentStationImageView.widthAnchor.constraint(equalToConstant: 16),
            currentStationImageView.heightAnchor.constraint(equalToConstant: 16),
            
            busStationTableView.topAnchor.constraint(equalTo: currentStationStackView.bottomAnchor, constant: 24),
            busStationTableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            busStationTableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            busStationTableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension DestinationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        busStationSearchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension DestinationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearched ? self.filteredStationList.count : self.stationRouteItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = .init()
        
        if isSearched {
            guard let filteredStationCell = busStationTableView.dequeueReusableCell(
                withIdentifier: DestinationSearchedTableViewCell.identifier,
                for: indexPath
            ) as? DestinationSearchedTableViewCell else {
                return UITableViewCell()
            }
            
            let station = filteredStationList[indexPath.row]
            let stationSequence = station.seq ?? "0"
            let nextStationIndex: Int = Int(stationSequence) ?? 0
            let isLastStation = nextStationIndex == stationRouteItemList.count
            let nextStation: String? = isLastStation
            ? nil
            : stationRouteItemList[nextStationIndex].stationNm
            
            filteredStationCell.setupCell(with: station, nextStation)
            
            cell = filteredStationCell
        } else {
            guard let busStationCell = busStationTableView.dequeueReusableCell(
                withIdentifier: DestinationTableViewCell.identifier,
                for: indexPath
            ) as? DestinationTableViewCell else {
                return UITableViewCell()
            }
            
            let stationRoute = stationRouteItemList[indexPath.row]
            let isLast = stationRouteItemList.endIndex - 1 == indexPath.row
            
            busStationCell.setupCell(
                item: stationRoute,
                isLast: isLast,
                indexPath: indexPath,
                nearestStationIndex: locationDataManager.nearestStationIndex
            )
            
            cell = busStationCell
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension DestinationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isSearched = false
            return
        }
        isSearched = true
        filteredStationList = stationRouteItemList.filter {
            let stationName = $0.stationNm ?? "알 수 없는 정류장"
            return stationName.contains(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        busStationSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        busStationSearchBar.resignFirstResponder()
    }
}

#Preview {
    DestinationViewController()
}
