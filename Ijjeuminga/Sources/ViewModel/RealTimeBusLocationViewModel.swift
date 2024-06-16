//
//  RealTimeBusLocationViewModel.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class RealTimeBusLocationViewModelOutput: BaseViewModelOutput {
}

class RealTimeBusLocationViewModel: BaseViewModel<RealTimeBusLocationViewModelOutput> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RealTimeBusLocationSectionData, RealTimeBusLocationData>
    
    lazy var dataSource: RealTimeBusLocationDataSource = {
        let dataSource = RealTimeBusLocationDataSource()
        return dataSource
    }()
    
    override init() {
        super.init()
        
    }
    
    override func attachView() {
        super.attachView()
        createSnapShot()
    }
    
    private func createSnapShot() {
        // Create a snapshot.
        var snapshot = Snapshot()

        // Populate the snapshot.
        let dataList: [RealTimeBusLocationData] = [
            .init(name: "마전지구버스차고지", type: .destination),
            .init(name: "마전지구버스차고지", type: .next),
            .init(name: "마전지구버스차고지", type: .current),
            .init(name: "마전지구버스차고지", type: .previous),
            .init(name: "마전지구버스차고지", type: .twoStopsAgo)
        ]
        let section: RealTimeBusLocationSectionData = .bus(data: dataList)
        snapshot.appendSections([section])
        snapshot.appendItems(dataList, toSection: section)
    
        // Apply the snapshot.
        dataSource.dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
