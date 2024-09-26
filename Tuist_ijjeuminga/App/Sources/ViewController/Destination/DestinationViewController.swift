//
//  DestinationViewController.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/06.
//

import Common
import UIKit

import RxSwift
import RxCocoa
import SkeletonView

class DestinationViewController: ViewModelInjectionBaseViewController<DestinationViewModel, DestinationViewModelOutput> {
    
    private weak var titleLabel: UILabel!
    private weak var backgroundView: UIView!
    private weak var destinationTitle: UILabel!
    private weak var busStationSearchBar: UISearchBar!
    private weak var currentStationStackView: UIStackView!
    private weak var currentStationImageView: UIImageView! // TODO: [] iconImageView로 이름 변경
    private weak var currentStationLabel: UILabel!
    private weak var busStationTableView: UITableView!
    
    private var dataList: [DestinationTableData] = []
    
    private var isSearched: Bool = false {
        didSet {
            configureTableView()
            currentStationStackView.isHidden = isSearched
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func bind() {
        super.bind()
        self.viewModel.output.busNumber
            .bind(to: titleLabel.rx.text)
            .disposed(by: viewDisposeBag)
        
        self.viewModel.output.tableData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.dataList = $0
                self?.busStationTableView.reloadData()
                self?.view.hideSkeleton()
            }.disposed(by: viewDisposeBag)
        
        self.viewModel.output.currentPosIndex
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] currentPosIndex in
                guard currentPosIndex != -1 else {
                    print("정류장 데이터가 없습니다\n잠시후 다시 시도해주세요")
                    return
                }
                self?.busStationTableView.scrollToRow(
                    at: IndexPath(row: currentPosIndex, section: 0),
                    at: .middle,
                    animated: true
                )
            }.disposed(by: viewDisposeBag)
        
        // MARK: - rx 수정필요
//        self.busStationSearchBar.rx.text.orEmpty
//            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .bind(to: self.viewModel.input.searchText)
//            .disposed(by: viewDisposeBag)
        
        self.viewModel.output.networkError
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                if let networkError = error as? CustomError.NetworkError {
                    self?.showErrorPopup(message: networkError.messageDescription)
                } else {
                    self?.showErrorPopup(message: error.localizedDescription)
                }
                
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func showErrorPopup(message: String) {
        let errorPopup = CustomAlertController()
            .setTitleMessage("네트워크 에러")
            .setContentMessage(message)
            .addaction("확인", .default)
            .build()
        
        present(errorPopup, animated: true)
    }
    
    @objc 
    private func tapCurrentStation() {
        viewModel.input.currentPosTapped.onNext(())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
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
        backgroundView.isSkeletonable = true
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        let destinationTitle = UILabel()
        destinationTitle.translatesAutoresizingMaskIntoConstraints = false
        destinationTitle.isSkeletonable = true
        destinationTitle.text = "목적지 선택"
        destinationTitle.font = .bold(24)
        backgroundView.addSubview(destinationTitle)
        self.destinationTitle = destinationTitle
        
        let busStationSearchBar = UISearchBar()
        busStationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        busStationSearchBar.isSkeletonable = true
        busStationSearchBar.placeholder = "정류장 검색"
        busStationSearchBar.backgroundImage = UIImage()
        busStationSearchBar.delegate = self
        backgroundView.addSubview(busStationSearchBar)
        self.busStationSearchBar = busStationSearchBar
        
        let currentStationTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentStation))
        let currentStationStackView = UIStackView()
        currentStationStackView.translatesAutoresizingMaskIntoConstraints = false
        currentStationStackView.isSkeletonable = true
        currentStationStackView.spacing = 4
        currentStationStackView.addGestureRecognizer(currentStationTapGesture)
        backgroundView.addSubview(currentStationStackView)
        self.currentStationStackView = currentStationStackView
        
        let currentStationImageView = UIImageView()
        currentStationImageView.translatesAutoresizingMaskIntoConstraints = false
        currentStationImageView.image = CommonAsset.target.image
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
        busStationTableView.isSkeletonable = true
        busStationTableView.delegate = self
        busStationTableView.dataSource = self
        busStationTableView.rowHeight = 54
        busStationTableView.estimatedRowHeight = 54 // skeleton은 이 높이를 기준으로 잡음
        busStationTableView.showsVerticalScrollIndicator = false
        busStationTableView.register(
            DestinationTableViewCell.self,
            forCellReuseIdentifier: DestinationTableViewCell.identifier
        )
        backgroundView.addSubview(busStationTableView)
        self.busStationTableView = busStationTableView
    
        backgroundView.showAnimatedGradientSkeleton()
        busStationTableView.showAnimatedGradientSkeleton()
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        backgroundView.setConstraintsToMatch(view, constant: 16)
        
        NSLayoutConstraint.activate([
            destinationTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            destinationTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            
            busStationSearchBar.topAnchor.constraint(equalTo: destinationTitle.bottomAnchor, constant: 16),
            busStationSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            busStationSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
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

// MARK: - UITableViewDataSource

extension DestinationViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = .init()
        
        guard let item = dataList[safe: indexPath.row] else { return UITableViewCell() }
        switch item {
        case .searchResult:
            guard let filteredStationCell = busStationTableView.dequeueReusableCell(
                withIdentifier: DestinationSearchedTableViewCell.identifier,
                for: indexPath
            ) as? DestinationSearchedTableViewCell else {
                return UITableViewCell()
            }

            filteredStationCell.configureCell(data: item)
            cell = filteredStationCell
            
        case .stationResult:
            guard let busStationCell = busStationTableView.dequeueReusableCell(
                withIdentifier: DestinationTableViewCell.identifier,
                for: indexPath
            ) as? DestinationTableViewCell else {
                return UITableViewCell()
            }
            
            busStationCell.configureCell(data: (item, indexPath.row))
            cell = busStationCell
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Skeleton
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        guard let item = dataList[safe: indexPath.row] else { return ReusableCellIdentifier() }
        switch item {
        case .searchResult:
            return DestinationSearchedTableViewCell.identifier
        case .stationResult:
            return DestinationTableViewCell.identifier
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return skeletonView.dequeueReusableCell(withIdentifier: DestinationTableViewCell.identifier, for: indexPath)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableView.automaticNumberOfSkeletonRows
    }
}

// MARK: - UITableViewDelegate

extension DestinationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        busStationSearchBar.resignFirstResponder()
        
        showRouteGuidePopup(dataList[indexPath.row])
    }
    
    private func showRouteGuidePopup(_ station: DestinationTableData) {
        let routeGuidePopup = CustomAlertController()
            .setTitleMessage("안내를 시작할까요?")
            .addaction("취소", .cancel)
            .addaction("시작", .default) { [weak self] _ in
                self?.viewModel.input.showRealTimeBusLocation.onNext(station)
            }
            .setPreferredAction(action: .default)
            .build()
        
        present(routeGuidePopup, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension DestinationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isSearched = false
            return
        }
        viewModel.input.searchText.onNext(searchText)
        isSearched = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        busStationSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        busStationSearchBar.resignFirstResponder()
    }
}

//#Preview {
//    DestinationViewController(viewModel: DestinationViewModel(routeId: "100100139", busColor: .greenBus))
//}
