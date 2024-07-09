//
//  DestinationViewController.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/06.
//

import UIKit

import RxSwift

class DestinationViewController: ViewModelInjectionBaseViewController<DestinationViewModel, DestinationViewModelOutput> {
    
    private weak var backgroundView: UIView!
    private weak var destinationTitle: UILabel!
    private weak var busStationSearchBar: UISearchBar!
    private weak var currentStationStackView: UIStackView!
    private weak var currentStationImageView: UIImageView!
    private weak var currentStationLabel: UILabel!
    private weak var busStationTableView: UITableView!
    
    
    private var dataList: [DestinationTableData] = []
    // TODO: [] 아래 프로퍼티 viewModel에서 처리
    private var stationRouteSubject = PublishSubject<[Rest.BusRouteInfo.ItemList]>()
    
    private var isSearched: Bool = false {
        didSet {
            configureTableView()
            currentStationStackView.isHidden = isSearched
        }
    }
    private let locationDataManager = LocationDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchStationByRoute()
//        bind()
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
    
    override func bind() {
        super.bind()
        self.viewModel.input = DestinationViewModelInput()
        self.viewModel.output.tableData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.dataList = $0
                self?.busStationTableView.reloadData()
            }.disposed(by: viewDisposeBag)
        
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
//        return isSearched ? self.filteredStationList.count : self.stationRouteItemList.count
        return dataList.count
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
            
//            let station = filteredStationList[indexPath.row]
//            let stationSequence = station.seq ?? "0"
//            let nextStationIndex: Int = Int(stationSequence) ?? 0
//            let isLastStation = nextStationIndex == stationRouteItemList.count
//            let nextStation: String? = isLastStation
//            ? nil
//            : stationRouteItemList[nextStationIndex].stationNm
            
//            filteredStationCell.setupCell(with: station, nextStation)
//            filteredStationCell.configureCell(data: <#T##DestinationTableData?#>)
            
            cell = filteredStationCell
        } else {
            guard let busStationCell = busStationTableView.dequeueReusableCell(
                withIdentifier: DestinationTableViewCell.identifier,
                for: indexPath
            ) as? DestinationTableViewCell else {
                return UITableViewCell()
            }
            let station = dataList[indexPath.row]
            busStationCell.configureCell(data: (station, indexPath.row))
            
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
        viewModel.input?.searchText.onNext(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        busStationSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        busStationSearchBar.resignFirstResponder()
    }
}

//#Preview {
//    DestinationViewController()
//}
