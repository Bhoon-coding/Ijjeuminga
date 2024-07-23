//
//  BusListViewController.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 6/16/24.
//

import UIKit
import CoreData
import AVFoundation
import RxSwift
import RxCocoa

class BusListViewController: ViewModelInjectionBaseViewController<BusListViewModel, BusListViewModelOutput> {

    private weak var titleLabel: UILabel!
    private weak var searchTextField: UITextField!
    private weak var searchTitleLabel: UILabel!
    private weak var dividingView: UIView!
    private weak var recentSearchListTableView: UITableView!
    private weak var searchListTableView: UITableView!
        
    private var container: NSPersistentContainer?
    
    private var recentSearchBusList = [RecentBusInfo]()
    private var searchedBusList = [BusInfo]()
    
    override func initView() {
        super.initView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Font.sandollGothicBold, size: 24)
        titleLabel.textColor = UIColor(named: Color.black)
        titleLabel.text = "버스 검색."
        self.view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.keyboardType = .numberPad
        searchTextField.addLeftPadding()
        searchTextField.layer.cornerRadius = 20
        searchTextField.backgroundColor = UIColor(named: Color.grayF2F2F2)
        searchTextField.placeholder = "버스 번호를 입력해주세요."
        searchTextField.textColor = UIColor(named: Color.black)
        searchTextField.font = UIFont(name: Font.sandollGothicBold, size: 15)
        self.view.addSubview(searchTextField)
        self.searchTextField = searchTextField
        
        let searchTitleLabel = UILabel()
        searchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTitleLabel.font = UIFont(name: Font.sandollGothicBold, size: 13)
        searchTitleLabel.textColor = UIColor(named: Color.grayCACACA)
        searchTitleLabel.text = "최근 검색 목록"
        self.view.addSubview(searchTitleLabel)
        self.searchTitleLabel = searchTitleLabel
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: Color.grayF4F4F4)
        self.view.addSubview(view)
        self.dividingView = view
        
        let recentSearchListTableView = UITableView()
        recentSearchListTableView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchListTableView.register(BusListTableViewCell.self, forCellReuseIdentifier: BusListTableViewCell.identifier)
        recentSearchListTableView.dataSource = self
        recentSearchListTableView.delegate = self
        recentSearchListTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(recentSearchListTableView)
        self.recentSearchListTableView = recentSearchListTableView
        
        let searchListTableView = UITableView()
        searchListTableView.translatesAutoresizingMaskIntoConstraints = false
        searchListTableView.register(BusListTableViewCell.self, forCellReuseIdentifier: BusListTableViewCell.identifier)
        searchListTableView.dataSource = self
        searchListTableView.delegate = self
        searchListTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchListTableView.isHidden = true
        self.view.addSubview(searchListTableView)
        self.searchListTableView = searchListTableView
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            
            self.searchTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 40),
            self.searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.searchTitleLabel.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 16),
            self.searchTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            
            self.dividingView.topAnchor.constraint(equalTo: self.searchTitleLabel.bottomAnchor, constant: 8),
            self.dividingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.dividingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.dividingView.heightAnchor.constraint(equalToConstant: 1),
            
            self.recentSearchListTableView.topAnchor.constraint(equalTo: self.dividingView.bottomAnchor, constant: 8),
            self.recentSearchListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.recentSearchListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.recentSearchListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16),
            
            self.searchListTableView.topAnchor.constraint(equalTo: self.dividingView.bottomAnchor, constant: 8),
            self.searchListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.searchListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.searchListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16)
        ])
    }
    
    override func bind() {
        super.bind()
        
        self.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchedText)
            .disposed(by: viewDisposeBag)
        
        self.viewModel.output.searchedBusList
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] searchedBusList in
                self?.searchedBusList = searchedBusList
                self?.searchListTableView.reloadData()
            }.disposed(by: viewDisposeBag)
        
        self.viewModel.output.recentBusList
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] recentSearchBusList in
                self?.recentSearchBusList = recentSearchBusList
                self?.recentSearchListTableView.reloadData()
            }.disposed(by: viewDisposeBag)
    }
}

extension BusListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.recentSearchListTableView:
            return self.recentSearchBusList.count
        case self.searchListTableView:
            return self.searchedBusList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.recentSearchListTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BusListTableViewCell.identifier, for: indexPath) as? BusListTableViewCell else {return UITableViewCell()}
            let busInfo = self.recentSearchBusList[indexPath.row]
            cell.configureCell(data: BusInfo(busNumber: busInfo.busNumer ?? "", routeId: busInfo.routeId ?? "", type: Int(busInfo.type), lastDate: self.getCurrentDateString()))
            cell.selectionStyle = .none
            return cell
        case self.searchListTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BusListTableViewCell.identifier, for: indexPath) as? BusListTableViewCell else {return UITableViewCell()}
            let busInfo = self.searchedBusList[indexPath.row]
            cell.configureCell(data: BusInfo(busNumber: busInfo.busNumber, routeId: busInfo.routeId, type: Int(busInfo.type), lastDate: self.getCurrentDateString()))
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension BusListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busInfo = self.searchedBusList[indexPath.row]
        CoreDataManager.shared.saveBusInfo(busNumber: busInfo.busNumber, routeId: busInfo.routeId, type: Int32(busInfo.type), lastDate: self.getCurrentDateString()) { result in
        }
    }
}

extension BusListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            self.recentSearchListTableView.isHidden = false
            self.searchListTableView.isHidden = true
            self.searchTitleLabel.text = "최근 검색 목록"
        } else {
            self.recentSearchListTableView.isHidden = true
            self.searchListTableView.isHidden = false
            self.searchTitleLabel.text = "검색 결과"
        }
    }
}
