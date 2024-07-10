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
}

class DestinationViewModelOutput: BaseViewModelOutput {
    let tableData = PublishSubject<[DestinationTableData]>()
}

class DestinationViewModel: BaseViewModel<DestinationViewModelOutput> {
    var input: DestinationViewModelInput? {
        didSet {
            initEvent()
        }
    }
    
    private var isSearched: Bool = false // TODO: [] createDataList() 구현부를 분기처리할때 사용하는데 isSearched를 viewModel, VC 둘중 하나만 사용할순 없을까
    private let locationDataManager = LocationDataManager()
    private var stationRouteItemList: [Rest.BusRouteInfo.ItemList] = []
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    
    private func initEvent() {
        guard let input = input else { return }
        locationDataManager.requestLocationAuth()
        fetchStationByRoute()
        
        input.searchText
            .subscribe { [weak self] textInput in
                guard let self = self, let text = textInput.element else { return }
                guard !text.isEmpty else {
                    self.isSearched = false
                    fetchStationByRoute()
                    return
                }
                self.isSearched = true
                self.filteredStationList = stationRouteItemList.filter {
                    let stationName = $0.stationNm ?? "알 수 없는 정류장"
                    return stationName.contains(text)
                }
                createDataList(with: filteredStationList)
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func fetchStationByRoute() {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: "100100124")
            .subscribe { [weak self] res in
                guard let resStationRouteList = res.msgBody.itemList else { return }
                self?.stationRouteItemList = resStationRouteList
                self?.createDataList(with: resStationRouteList)

            } onFailure: { error in
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
    }
    
    func createDataList(with list: [Rest.BusRouteInfo.ItemList]) {
        var newList: [DestinationTableData]
        
        if self.isSearched {
            newList = list.compactMap { item in
                guard let stationName = item.stationNm,
                      let sequence = item.seq,
                      let seqInt = Int(sequence)
                else {
                    return nil
                }
                let nextItem = stationRouteItemList.count > seqInt
                ? "\(stationRouteItemList[seqInt].stationNm!) 방향" // TODO: [] forced(!) 말고 다른방법?
                : "종점"
                return DestinationTableData.searchResult(
                    station: item,
                    nextStation: nextItem
                )
            }
        } else {
            newList = list.enumerated().map { index, itemList in
                return DestinationTableData.stationResult(
                    station: itemList,
                    isLast: index == list.count - 1,
                    nearestStationIndex: locationDataManager.nearestStationIndex
                )
            }
        }
        output.tableData.onNext(newList)
    }
}

enum DestinationTableData {
    
    case searchResult(station: Rest.BusRouteInfo.ItemList, nextStation: String)
    case stationResult(station: Rest.BusRouteInfo.ItemList, isLast: Bool, nearestStationIndex: Int)
    
}

