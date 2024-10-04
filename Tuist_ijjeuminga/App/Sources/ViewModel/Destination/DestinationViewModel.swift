//
//  DestinationViewModel.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/10.
//

import Common
import UIKit
import RxSwift

class DestinationViewModelInput: BaseViewModelInput {
    let searchText = PublishSubject<String>()
    let currentPosTapped = PublishSubject<Void>()
    let routeId = PublishSubject<String>()
    let showRealTimeBusLocation = PublishSubject<DestinationTableData>()
}

class DestinationViewModelOutput: BaseViewModelOutput {
    let tableData = PublishSubject<[DestinationTableData]>()
    let currentPosIndex = PublishSubject<Int>()
    let busNumber = PublishSubject<String>()
    let close = PublishSubject<Void>()
    let networkError = PublishSubject<Error>()
}

class DestinationViewModel: BaseViewModel<DestinationViewModelOutput> {
    
    let input = DestinationViewModelInput()
    let busType: KoreaBusType.RawValue

    private var currentPosIndex: Int = -1
    private var stationList: [Rest.BusRouteInfo.ItemList] = [] {
        didSet {
            if let busNumber = stationList.first?.busRouteAbrv {
                output.busNumber.onNext(busNumber)
            }
        }
    }
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    private let routeId: String
    private let seq: String
    
    
    init(busType: KoreaBusType.RawValue, routeId: String, seq: String) {
        self.busType = busType
        self.routeId = routeId
        self.seq = seq
    }
    
    override func attachView() {
        fetchStationByRoute(with: self.routeId)
        LocationDataManager.shared.requestLocationAuth()
        
        input.searchText
            .subscribe { [weak self] textInput in
                guard let self = self, let text = textInput.element else { return }
                guard !text.isEmpty else {
                    fetchStationByRoute(with: routeId)
                    return
                }
                self.filteredStationList = stationList.filter {
                    let stationName = $0.stationNm ?? ""
                    return stationName.contains(text)
                }
                createFilteredDataList(with: filteredStationList)
            }
            .disposed(by: viewDisposeBag)
        
        input.currentPosTapped
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.output.currentPosIndex.onNext(self.currentPosIndex)
            }
            .disposed(by: viewDisposeBag)
        
        input.showRealTimeBusLocation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .searchResult(station: let destination, _, _),
                        .stationResult(station: let destination, _, _, _):
                    guard let stationId = destination.station,
                          let stationList = self?.stationList,
                          let index = self?.currentPosIndex,
                          index < stationList.count,
                          let startId = stationList[index].station else {
                        return
                    }
                    self?.openRealTimeBusLocation(startId: startId, destinationId: stationId)
                }
            })
            .disposed(by: viewDisposeBag)
    }
    
    private func fetchStationByRoute(with routeId: String) {
        self.output.showIndicator.onNext(true)
        BusRouteInfoAPIService()
            .getStaionByRoute(with: routeId)
            .subscribe { [weak self] res in
                guard let stationList = res.msgBody.itemList else { return }
                self?.stationList = stationList
                self?.getCurrentPosition(stationList: stationList)
                self?.output.showIndicator.onNext(false)
            } onFailure: { [weak self] error in
                self?.output.error.onNext((error, {
                    self?.output.showIndicator.onNext(false)
                    self?.output.close.onNext(())
                }))
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
    }
    
    private func getCurrentPosition(stationList: [Rest.BusRouteInfo.ItemList]) {
        if let nearestIndex = stationList.firstIndex(where: { $0.seq == self.seq }) {
            self.currentPosIndex = nearestIndex
            createDataList(with: stationList, at: nearestIndex)
        }
    }
    
    func createDataList(with list: [Rest.BusRouteInfo.ItemList], at nearIndex: Int) {
        let newList = list.enumerated().map { index, itemList in
            return DestinationTableData.stationResult(
                station: itemList,
                isLast: index == list.count - 1,
                nearestIndex: nearIndex,
                busType: self.busType
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.output.tableData.onNext(newList)
            self.output.currentPosIndex.onNext(self.currentPosIndex)
        }
        
    }
    
    func createFilteredDataList(with list: [Rest.BusRouteInfo.ItemList]) {
        let newList: [DestinationTableData] = list.compactMap { item in
            guard let seqString = item.seq,
                  let seq = Int(seqString),
                  let stationName = stationList[safe: seq]?.stationNm else {
                return nil
            }
            
            let nextItem = stationList.count > seq
            ? "\(stationName) 방향"
            : "종점"
            return DestinationTableData.searchResult(
                station: item,
                nextStation: nextItem,
                busType: self.busType
            )
        }
        
        output.tableData.onNext(newList)
    }
    
    private func openRealTimeBusLocation(startId: String, destinationId: String) {
        let viewModel = RealTimeBusLocationViewModel(busRouteId: routeId,
                                                     startBusStopId: startId,
                                                     destinationBusStopId: destinationId, 
                                                     busType: busType)
        let controller = RealTimeBusLocationViewController(viewModel: viewModel)
        viewModel.output.close
            .bind(to: output.close)
            .disposed(by: disposeBag)
        output.pushVC.onNext((controller, true))
    }
}

enum DestinationTableData {
    
    case searchResult(
        station: Rest.BusRouteInfo.ItemList,
        nextStation: String,
        busType: KoreaBusType.RawValue
    )
    case stationResult(
        station: Rest.BusRouteInfo.ItemList,
        isLast: Bool,
        nearestIndex: Int,
        busType: KoreaBusType.RawValue
    )
    
}
