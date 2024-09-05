//
//  BaseTableDiffableDataSource.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableDiffableDataSoceurce<SectionIdType, ItemIdType>: NSObject
where SectionIdType: Hashable,
      SectionIdType: Sendable,
      ItemIdType: Hashable,
      ItemIdType: Sendable {
    
    typealias DataSource = UITableViewDiffableDataSource< SectionIdType, ItemIdType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdType, ItemIdType>
    
    var dataSource: DataSource!
    var tableView: UITableView?
    
    func bind(_ tableView: UITableView) {
        self.tableView = tableView
        let dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            return self?.cellForRow(tableView, indexPath, itemIdentifier)
        }
        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }
    
    func cellForRow(_ tableView: UITableView,
                    _ indexPath: IndexPath,
                    _ itemIdentifier: ItemIdType)
    -> UITableViewCell? {
        fatalError("should be overrided")
    }
}
