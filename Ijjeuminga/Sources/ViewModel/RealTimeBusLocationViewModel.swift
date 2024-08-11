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
import AVFoundation

class RealTimeBusLocationViewModelOutput: BaseViewModelOutput {
    let busNumber = PublishSubject<String>()
    let close = PublishSubject<Void>()
}

class RealTimeBusLocationViewModel: BaseViewModel<RealTimeBusLocationViewModelOutput> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RealTimeBusLocationSectionData, RealTimeBusLocationData>
    typealias RealTimeBusInfo = Rest.RealTimeBus.ItemList
    typealias BusPositionInfo = Rest.BusPosition.ItemList
    typealias BusStopInfo = Rest.BusRouteInfo.ItemList
    
    lazy var dataSource: RealTimeBusLocationDataSource = {
        let dataSource = RealTimeBusLocationDataSource()
        return dataSource
    }()
    
    private let busRouteId: String
    private let destinationBusStopId: String
    
    private var timerDisposeBag = DisposeBag()
    private var currentBusRouteNumber: String = "" {
        didSet {
            if oldValue != currentBusRouteNumber {
                output.busNumber.onNext(currentBusRouteNumber)
            }
        }
    }
    private var currentBusVehID: String = ""
    private var currentBusPositionInfo: RealTimeBusInfo?
    private var busStopList: [BusStopInfo] = []
    
    private var remainingBusStopCount: Int? {
        let busStopId = currentBusPositionInfo?.lastStnId ?? ""
        
        if let index1 = busStopList.firstIndex(where: { $0.station == busStopId }),
           let index2 = busStopList.firstIndex(where: { $0.station == destinationBusStopId }),
           abs(index1 - index2) <= 3 {
            return abs(index1 - index2)
        }
        return nil
    }
    
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
            self?.busStopList = station.msgBody.itemList ?? []
            return LocationDataManager.shared.compareLocation(to: busPos.msgBody.itemList ?? [])
        })
        .flatMap({ [weak self] data -> Observable<Rest.RealTimeBus.RealTimeBusResponse> in
            guard let vehId = data.vehId,
                  !vehId.isEmpty,
                  let stationList = self?.busStopList,
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
            self?.startTimer()
            self?.notice()
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
                self?.notice()
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
        let busStopId = currentBusPositionInfo?.lastStnId ?? ""
        
        if let index1 = busStopList.firstIndex(where: { $0.station == busStopId }),
           let index2 = busStopList.firstIndex(where: { $0.station == destinationBusStopId }) {
            let current = busStopList[index1]
            let destination = busStopList[index2]
            dataList.append(.init(name: destination.stationNm ?? "",
                                  type: .destination))
            
            if index1 < index2 {
                if index1 + 1 < index2 {
                    let next = busStopList[index1 + 1]
                    dataList.append(.init(name: next.stationNm ?? "",
                                          type: .next))
                }
                
                dataList.append(.init(name: current.stationNm ?? "",
                                      type: .current))
                
                if index1 - 1 >= 0 {
                    let previous = busStopList[index1 - 1]
                    dataList.append(.init(name: previous.stationNm ?? "",
                                          type: .previous))
                }
                
                if index1 - 2 >= 0 {
                    let twoStopsAgo = busStopList[index1 - 2]
                    dataList.append(.init(name: twoStopsAgo.stationNm ?? "", 
                                          type: .twoStopsAgo))
                }
            } else if index1 > index2 {
                if index1 - 1 > index2 {
                    let next = busStopList[index1 - 1]
                    dataList.append(.init(name: next.stationNm ?? "",
                                          type: .next))
                }
                
                dataList.append(.init(name: current.stationNm ?? "",
                                      type: .current))
                
                if index1 + 1 >= 0 {
                    let previous = busStopList[index1 + 1]
                    dataList.append(.init(name: previous.stationNm ?? "",
                                          type: .previous))
                }
                
                if index1 + 2 >= 0 {
                    let twoStopsAgo = busStopList[index1 + 2]
                    dataList.append(.init(name: twoStopsAgo.stationNm ?? "",
                                          type: .twoStopsAgo))
                }
            }
        }
        return dataList
    }
    
    private func notice() {
        guard let count = self.remainingBusStopCount,
              count >= 0 && count <= 3 else {
            return
        }
        
        if count == 0 {
            finish()
            return
        }
        
        var countText = ""
        switch count {
        case 1:
            countText = "한"
        case 2:
            countText = "두"
        case 3:
            countText = "세"
        default:
            break
        }
        
        vibrate()
        speak(text: "도착까지 \(countText) 정거장 남았습니다")
    }
    
    private func finish() {
        self.timerDisposeBag = DisposeBag()
        
        let closePopup = CustomAlertController()
            .setTitleMessage("안내를 종료합니다.")
            .addaction("확인", .default) { [weak self] _ in
                self?.output.close.onNext(())
            }
            .setPreferredAction(action: .default)
            .build()
        
        output.presentVC.onNext((closePopup, true))
    }
    
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    private func speak(text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    private func startTimer() {
        timerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(15), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let vehId = self?.currentBusVehID else {
                    return
                }
                self?.loadBusPosition(vehId: vehId)
            }
            .disposed(by: timerDisposeBag)
    }
}
