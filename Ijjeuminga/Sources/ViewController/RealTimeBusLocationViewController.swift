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
    
    private var tableView: UITableView!
    private var dataList: [Int] = []
    
    override func initView() {
        super.initView()
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BusStopStatusTableViewCell.self,
                           forCellReuseIdentifier: BusStopStatusTableViewCell.id)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.setConstraintsToMatch(view)
        
        viewModel.dataSource.bind(tableView)
        tableView.rx.setDelegate(viewModel.dataSource)
            .disposed(by: disposeBag)
    }
}
