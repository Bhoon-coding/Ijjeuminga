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
    let currentPosTapped = PublishSubject<Bool>()
}

class DestinationViewModelOutput: BaseViewModelOutput {
    let tableData = PublishSubject<[DestinationTableData]>()
    let currentPosIndex = PublishSubject<Int>()
}

class DestinationViewModel: BaseViewModel<DestinationViewModelOutput> {
    var locationDataManager: LocationDataManageable
    
    init(locationDataManager: LocationDataManageable) {
        self.locationDataManager = locationDataManager
    }
    
    var input: DestinationViewModelInput? {
        didSet {
            initEvent()
        }
    }

    private var currentPosIndex: Int = -1
    private var stationList: [Rest.BusRouteInfo.ItemList] = []
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    
    private func initEvent() {
        guard let input = input else { return }
        fetchStationByRoute()
        locationDataManager.requestLocationAuth()
        
        input.searchText
            .subscribe { [weak self] textInput in
                guard let self = self, let text = textInput.element else { return }
                guard !text.isEmpty else {
                    fetchStationByRoute()
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
        
        // TODO: [] viewModel의 input 형태로 만들어야 하나?
        locationDataManager.output.nearestIndex
            .subscribe { [weak self] nearIndex in
                guard let self = self else { return }
                self.currentPosIndex = nearIndex
                createDataList(with: stationList, at: nearIndex)
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func fetchStationByRoute() {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: "100100124")
            .subscribe { [weak self] res in
                guard let stationList = res.msgBody.itemList else { return }
                self?.stationList = stationList
                self?.locationDataManager.input.stations.onNext(stationList)
            } onFailure: { error in
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
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
}

enum DestinationTableData {
    
    case searchResult(station: Rest.BusRouteInfo.ItemList, nextStation: String)
    case stationResult(station: Rest.BusRouteInfo.ItemList, isLast: Bool, nearestIndex: Int)
    
}

