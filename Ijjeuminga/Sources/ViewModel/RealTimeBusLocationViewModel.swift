//
//  RealTimeBusLocationViewModel.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class RealTimeBusLocationViewModelOutput: BaseViewModelOutput {
}

class RealTimeBusLocationViewModel: BaseViewModel<RealTimeBusLocationViewModelOutput> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RealTimeBusLocationSectionData, RealTimeBusLocationData>
    typealias RealTimeBusInfo = Rest.RealTimeBus.ItemList
    typealias BusPositionInfo = Rest.BusPosition.ItemList
    typealias BusStationInfo = Rest.BusRouteInfo.ItemList
    
    lazy var dataSource: RealTimeBusLocationDataSource = {
        let dataSource = RealTimeBusLocationDataSource()
        return dataSource
    }()
    
    private let busRouteId: String
    private let destinationBusStopId: String
    
    private var currentBusRouteNumber: String = ""
    private var currentBusVehID: String = ""
    private var currentBusPositionInfo: RealTimeBusInfo?
    private var busStationList: [BusStationInfo] = []
    
    init(busRouteId: String, destinationBusStopId: String) {
        self.busRouteId = busRouteId
        self.destinationBusStopId = destinationBusStopId
        
        super.init()
    }
    
    override func attachView() {
        super.attachView()
        
        loadData(with: busRouteId)
    }
    
    private func loadData(with routeId: String) {
        Observable.zip(
            BusRouteInfoAPIService().getStaionByRoute(with: routeId)
                .asObservable(),
            BusPositionAPIService().getBusPosition(with: routeId)
                .asObservable()
        )
        .flatMap({ [weak self] (station, busPos) -> Observable<BusPositionInfo> in
            self?.busStationList = station.msgBody.itemList ?? []
            return LocationDataManager.shared.compareLocation(to: busPos.msgBody.itemList ?? [])
        })
        .flatMap({ [weak self] data -> Observable<Rest.RealTimeBus.RealTimeBusResponse> in
            guard let vehId = data.vehId,
                  !vehId.isEmpty,
                  let stationList = self?.busStationList,
                  !stationList.isEmpty else {
                return .never()
            }
            
            self?.currentBusVehID = vehId
            if let busRouteNumber = stationList.first?.busRouteAbrv {
                self?.currentBusRouteNumber = busRouteNumber
            }
            return RealTimeBusAPIService().getRealTimeBus(with: vehId).asObservable()
        })
        .subscribe { [weak self] data in
            guard let busInfo = data.msgBody.itemList?.first else {
                return
            }
            
            self?.currentBusPositionInfo = busInfo
            self?.createSnapShot()
        }
        .disposed(by: viewDisposeBag)
    }
    
    private func loadBusPosition(vehId: String) {
        RealTimeBusAPIService().getRealTimeBus(with: vehId)
            .subscribe { [weak self] data in
                guard let busInfo = data.msgBody.itemList?.first else {
                    return
                }
                
                self?.currentBusPositionInfo = busInfo
                self?.createSnapShot()
            } onFailure: { error in
                Log.error(error.localizedDescription)
            }
            .disposed(by: viewDisposeBag)
    }
        
    private func createSnapShot() {
        // Create a snapshot.
        var snapshot = Snapshot()

        // Populate the snapshot.
        let dataList = createDataList()
        let section: RealTimeBusLocationSectionData = .bus(data: dataList)
        snapshot.appendSections([section])
        snapshot.appendItems(dataList, toSection: section)
    
        // Apply the snapshot.
        dataSource.dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func createDataList() -> [RealTimeBusLocationData] {
        var dataList: [RealTimeBusLocationData] = []
        let busStationID = currentBusPositionInfo?.lastStnId ?? ""
        
        if let index1 = busStationList.firstIndex(where: { $0.station == busStationID }),
           let index2 = busStationList.firstIndex(where: { $0.station == destinationBusStopId }) {
            let current = busStationList[index1]
            let destination = busStationList[index2]
            dataList.append(.init(name: destination.stationNm ?? "",
                                  type: .destination))
            
            if index1 < index2 {
                if index1 + 1 < index2 {
                    let next = busStationList[index1 + 1]
                    dataList.append(.init(name: next.stationNm ?? "",
                                          type: .next))
                }
                
                dataList.append(.init(name: current.stationNm ?? "",
                                      type: .current))
                
                if index1 - 1 >= 0 {
                    let previous = busStationList[index1 - 1]
                    dataList.append(.init(name: previous.stationNm ?? "",
                                          type: .previous))
                }
                
                if index1 - 2 >= 0 {
                    let twoStopsAgo = busStationList[index1 - 2]
                    dataList.append(.init(name: twoStopsAgo.stationNm ?? "", 
                                          type: .twoStopsAgo))
                }
            } else if index1 > index2 {
                if index1 - 1 > index2 {
                    let next = busStationList[index1 - 1]
                    dataList.append(.init(name: next.stationNm ?? "",
                                          type: .next))
                }
                
                dataList.append(.init(name: current.stationNm ?? "",
                                      type: .current))
                
                if index1 + 1 >= 0 {
                    let previous = busStationList[index1 + 1]
                    dataList.append(.init(name: previous.stationNm ?? "",
                                          type: .previous))
                }
                
                if index1 + 2 >= 0 {
                    let twoStopsAgo = busStationList[index1 + 2]
                    dataList.append(.init(name: twoStopsAgo.stationNm ?? "",
                                          type: .twoStopsAgo))
                }
            }
        }
        return dataList
    }
 
    private func notice() {} // 3 정거장 전부터 음성 안내 및 진동
    private func finish() {} // 종료
}
