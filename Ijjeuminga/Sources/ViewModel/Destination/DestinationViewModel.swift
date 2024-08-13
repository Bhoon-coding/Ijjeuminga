//
//  DestinationViewModel.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/10.
//

import Foundation

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
    let close = PublishSubject<Void>()
}

class DestinationViewModel: BaseViewModel<DestinationViewModelOutput> {
    
    let input = DestinationViewModelInput()

    private var currentPosIndex: Int = -1
    private var stationList: [Rest.BusRouteInfo.ItemList] = []
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    private var routeId: String
    
    init(routeId: String) {
        self.routeId = routeId
    }
    
    override func attachView() {
        fetchStationByRoute(with: routeId)
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
                case .searchResult(station: let destination, _),
                        .stationResult(station: let destination, _, _):
                    guard let stationId = destination.station else {
                        return
                    }
                    self?.openRealTimeBusLocation(destinationId: stationId)
                }
            })
            .disposed(by: viewDisposeBag)
    }
    
    private func fetchStationByRoute(with routeId: String) {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: routeId)
            .subscribe { [weak self] res in
                guard let stationList = res.msgBody.itemList else { return }
                self?.stationList = stationList
                self?.getCurrentPosition(stationList: stationList)
            } onFailure: { error in
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
    }
    
    private func getCurrentPosition(stationList: [Rest.BusRouteInfo.ItemList]) {
        LocationDataManager.shared.compareLocation(to: stationList)
            .subscribe { [weak self] nearestIndex in
                guard let self = self else { return }
                self.currentPosIndex = nearestIndex
                createDataList(with: stationList, at: nearestIndex)
            }
            .disposed(by: viewDisposeBag)
    }
    
    func createDataList(with list: [Rest.BusRouteInfo.ItemList], at nearIndex: Int) {
        let newList = list.enumerated().map { index, itemList in
            return DestinationTableData.stationResult(
                station: itemList,
                isLast: index == list.count - 1,
                nearestIndex: nearIndex
            )
        }
        
        output.tableData.onNext(newList)
        output.currentPosIndex.onNext(self.currentPosIndex)
    }
    
    func createFilteredDataList(with list: [Rest.BusRouteInfo.ItemList]) {
        let newList: [DestinationTableData] = list.compactMap { item in
            guard let seqString = item.seq, let seq = Int(seqString),
                  let stationName = stationList[safe: seq]?.stationNm
            else {
                return nil
            }
            let nextItem = stationList.count > seq
            ? "\(stationName) 방향"
            : "종점"
            return DestinationTableData.searchResult(
                station: item,
                nextStation: nextItem
            )
        }
        
        output.tableData.onNext(newList)
    }
    
    private func openRealTimeBusLocation(destinationId: String) {
        let viewModel = RealTimeBusLocationViewModel(busRouteId: routeId, destinationBusStopId: destinationId)
        let controller = RealTimeBusLocationViewController(viewModel: viewModel)
        viewModel.output.close
            .bind(to: output.close)
            .disposed(by: disposeBag)
        output.pushVC.onNext((controller, true))
    }
}

enum DestinationTableData {
    
    case searchResult(station: Rest.BusRouteInfo.ItemList, nextStation: String)
    case stationResult(station: Rest.BusRouteInfo.ItemList, isLast: Bool, nearestIndex: Int)
    
}

