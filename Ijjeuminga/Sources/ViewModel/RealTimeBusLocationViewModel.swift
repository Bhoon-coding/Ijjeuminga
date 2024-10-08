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

class RealTimeBusLocationViewModelInput: BaseViewModelInput {
    let updateBusLocation = PublishSubject<Void>()
}

class RealTimeBusLocationViewModelOutput: BaseViewModelOutput {
    let busNumber = PublishSubject<String>()
    let close = PublishSubject<Void>()
    let startTimer = PublishSubject<Int>()
    let stopTimer = PublishSubject<Void>()
    let enableButton = PublishSubject<Bool>()
}

class RealTimeBusLocationViewModel: BaseViewModel<RealTimeBusLocationViewModelOutput> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RealTimeBusLocationSectionData, RealTimeBusLocationData>
    typealias RealTimeBusInfo = Rest.RealTimeBus.ItemList
    typealias BusPositionInfo = Rest.BusPosition.ItemList
    typealias BusStopInfo = Rest.BusRouteInfo.ItemList
    
    var input = RealTimeBusLocationViewModelInput()
    
    lazy var dataSource: RealTimeBusLocationDataSource = {
        let dataSource = RealTimeBusLocationDataSource()
        return dataSource
    }()

    private var currentBusRouteNumber: String = "" {
        didSet {
            if oldValue != currentBusRouteNumber {
                output.busNumber.onNext(currentBusRouteNumber)
            }
        }
    }
    private var currentBusVehID: String = ""
    private var currentBusPositionInfo: RealTimeBusInfo?
    private var busStopList: [BusStopInfo] = [] {
        didSet {
            if let busRouteNumber = busStopList.first?.busRouteAbrv {
                self.currentBusRouteNumber = busRouteNumber
            }
        }
    }
    private var remainingBusStopCount: Int? {
        let busStopId = currentBusPositionInfo?.lastStnId ?? ""
        
        if let index1 = busStopList.firstIndex(where: { $0.station == busStopId }),
           let index2 = busStopList.firstIndex(where: { $0.station == destinationBusStopId }),
           abs(index1 - index2) <= 3 {
            return abs(index1 - index2)
        }
        return nil
    }
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let busRouteId: String
    private let startBusStopId: String
    private let destinationBusStopId: String
    let busColor: UIColor
    
    init(busRouteId: String,
         startBusStopId: String,
         destinationBusStopId: String,
         busColor: UIColor) {
        self.busRouteId = busRouteId
        self.startBusStopId = startBusStopId
        self.destinationBusStopId = destinationBusStopId
        self.busColor = busColor
        
        super.init()
    }
    
    override func attachView() {
        super.attachView()
        
        createSnapShot()
        loadData(with: busRouteId)
        
        input.updateBusLocation
            .subscribe { [weak self] _ in
                guard let vehId = self?.currentBusVehID else {
                    return
                }
                self?.loadBusPosition(vehId: vehId)
            }
            .disposed(by: viewDisposeBag)
    }

    private func loadData(with routeId: String) {
        output.showIndicator.onNext(true)
        output.enableButton.onNext(false)
        
        BusRouteInfoAPIService().getStaionByRoute(with: routeId)
            .map { $0.msgBody.itemList ?? [] }
            .asObservable()
            .filter { [weak self] busStopList in
                self?.showErrorAlert(busStopList.isEmpty, text: "예기치 못한 문제가 발생했습니다.")
                return !busStopList.isEmpty
            }
            .flatMap { [weak self] list -> Observable<[BusPositionInfo]> in
                self?.busStopList = list
                return BusPositionAPIService()
                    .getBusPosition(busRouteId: routeId,
                                    startOrd: list.first(where: { $0.station == self?.startBusStopId })?.seq ?? "1",
                                    endOrd: list.first(where: { $0.station == self?.destinationBusStopId })?.seq ?? "10")
                    .map { $0.msgBody.itemList ?? [] }
                    .asObservable()
            }
            .filter { [weak self] data in
                self?.showErrorAlert(data.isEmpty, text: "출발지에서 목적지까지 구간 내에 운행 중인 버스가 없습니다.")
                return !data.isEmpty
            }
            .flatMap { data -> Observable<String> in
                return LocationDataManager.shared.compareLocation(to: data)
                    .map { $0.vehId ?? "" }
            }
            .flatMap { [weak self] vehId -> Observable<Rest.RealTimeBus.RealTimeBusResponse> in
                self?.currentBusVehID = vehId
                return RealTimeBusAPIService().getRealTimeBus(with: vehId)
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] data in
                guard let busInfo = data.msgBody.itemList?.first else {
                    return
                }
                
                let previous = self?.currentBusPositionInfo
                self?.currentBusPositionInfo = busInfo
                self?.createSnapShot()
                self?.output.startTimer.onNext(15)
                self?.notice(previousInfo: previous, currentInfo: busInfo)
                self?.output.showIndicator.onNext(false)
                self?.output.enableButton.onNext(true)
            }, onError: { error in
                Log.error(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.output.showIndicator.onNext(false)
            })
            .disposed(by: viewDisposeBag)
    }
    
    private func loadBusPosition(vehId: String) {
        RealTimeBusAPIService().getRealTimeBus(with: vehId)
            .subscribe { [weak self] data in
                guard let busInfo = data.msgBody.itemList?.first else {
                    return
                }
                let previous = self?.currentBusPositionInfo
                self?.currentBusPositionInfo = busInfo
                self?.createSnapShot()
                self?.notice(previousInfo: previous, currentInfo: busInfo)
            } onFailure: { [weak self] error in
                Log.error(error.localizedDescription)
                self?.output.startTimer.onNext(15)
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
        let busStopId = currentBusPositionInfo?.lastStnId ?? ""
        var dataList: [RealTimeBusLocationData] = [
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous)
        ]

        guard let index1 = busStopList.firstIndex(where: { $0.station == busStopId }),
              let index2 = busStopList.firstIndex(where: { $0.station == destinationBusStopId }) else {
            return dataList
        }
        
        let destination = busStopList[index2]

        if index1 < index2 {
            return createForwardDataList(currentIndex: index1,
                                         destinationIndex: index2,
                                         busStopList: busStopList)
        } else if index1 > index2 {
            return createBackwardDataList(currentIndex: index1,
                                          destinationIndex: index2,
                                          busStopList: busStopList)
        } else {
            dataList[2] = .init(name: destination.stationNm ?? "", type: .destination)
            return dataList
        }
    }
    
    private func createForwardDataList(currentIndex: Int,
                                       destinationIndex: Int,
                                       busStopList: [BusStopInfo]) -> [RealTimeBusLocationData] {
        var dataList: [RealTimeBusLocationData] = [
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous)
        ]
        
        dataList[2] = .init(name: busStopList[currentIndex].stationNm ?? "", type: .current)
        
        if currentIndex + 1 < destinationIndex {
            dataList[0] = .init(name: busStopList[destinationIndex].stationNm ?? "", type: .destination)
            dataList[1] = .init(name: busStopList[currentIndex + 1].stationNm ?? "", type: .next)
        } else {
            dataList[1] = .init(name: busStopList[destinationIndex].stationNm ?? "", type: .destination)
        }
        
        if currentIndex - 1 >= 0 {
            dataList[3] = .init(name: busStopList[currentIndex - 1].stationNm ?? "", type: .previous)
        }
        
        if currentIndex - 2 >= 0 {
            dataList[4] = .init(name: busStopList[currentIndex - 2].stationNm ?? "", type: .twoStopsAgo)
        }
        
        return dataList
    }
    
    private func createBackwardDataList(currentIndex: Int,
                                        destinationIndex: Int,
                                        busStopList: [BusStopInfo]) -> [RealTimeBusLocationData] {
        var dataList: [RealTimeBusLocationData] = [
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous),
            .init(name: "정류장에 대한 정보가 없습니다", type: .previous)
        ]
        
        dataList[2] = .init(name: busStopList[currentIndex].stationNm ?? "", type: .current)
        
        if currentIndex - 1 > destinationIndex {
            dataList[0] = .init(name: busStopList[destinationIndex].stationNm ?? "", type: .destination)
            dataList[1] = .init(name: busStopList[currentIndex - 1].stationNm ?? "", type: .next)
        } else {
            dataList[1] = .init(name: busStopList[destinationIndex].stationNm ?? "", type: .destination)
        }
        
        if currentIndex + 1 >= 0 {
            dataList[3] = .init(name: busStopList[currentIndex + 1].stationNm ?? "", type: .previous)
        }
        
        if currentIndex + 2 >= 0 {
            dataList[4] = .init(name: busStopList[currentIndex + 2].stationNm ?? "", type: .twoStopsAgo)
        }
        return dataList
    }
    
    private func notice(previousInfo: RealTimeBusInfo?,
                        currentInfo: RealTimeBusInfo) {
        guard currentInfo.lastStnId != (previousInfo?.lastStnId ?? ""),
              let count = self.remainingBusStopCount,
              count >= 0 && count <= 3,
              currentInfo.stopFlag == "1" else {
            output.startTimer.onNext(15)
            return
        }
        
        if count == 0 {
            output.stopTimer.onNext(())
            vibrate()
            speak(text: "목적지에 도착했습니다")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showFinishAlert()
            }
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
        output.startTimer.onNext(15)
    }
    
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    private func speak(text: String) {
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
           try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.error(error)
        }

        let speechUtterance = AVSpeechUtterance(string: text)
        self.speechSynthesizer.speak(speechUtterance)
    }
}

// MARK: alert
extension RealTimeBusLocationViewModel {
    private func showFinishAlert() {
        let closePopup = CustomAlertController()
            .setTitleMessage("안내를 종료합니다.")
            .addaction("확인", .default) { [weak self] _ in
                self?.output.close.onNext(())
            }
            .setPreferredAction(action: .default)
            .build()
        
        output.presentVC.onNext((closePopup, true))
    }
    
    private func showErrorAlert(_ show: Bool, text: String) {
        guard show else {
            return
        }
        
        let closePopup = CustomAlertController()
            .setTitleMessage(text)
            .addaction("닫기", .default) { [weak self] _ in
                self?.output.close.onNext(())
            }
            .setPreferredAction(action: .default)
            .build()
        
        output.presentVC.onNext((closePopup, true))
    }
}
