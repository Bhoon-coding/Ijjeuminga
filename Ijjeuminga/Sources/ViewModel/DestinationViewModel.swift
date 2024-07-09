//
//  DestinationViewModel.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/10.
//

import Foundation

import RxSwift

class DestinationViewModelInput: BaseViewModelInput {
    // TODO: [] 사용자의 이벤트 > 로직연산이 필요한 부분
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
    
    private let locationDataManager = LocationDataManager()
    private var stationRouteItemList: [Rest.BusRouteInfo.ItemList] = []
    private var filteredStationList: [Rest.BusRouteInfo.ItemList] = []
    
    private func initEvent() {
        guard let input = input else { return }
        fetchStationByRoute()
        
        input.searchText
            .subscribe { [weak self] text in
                guard let stationRouteItemList = self?.stationRouteItemList else { return }
                self?.filteredStationList = stationRouteItemList.filter {
                    let stationName = $0.stationNm ?? "알 수 없는 정류장"
                    return stationName.contains(text)
                }
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func fetchStationByRoute() {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: "100100124")
            .subscribe { [weak self] res in
                guard let resStationRoute = res.msgBody.itemList else { return }
                self?.createDataList(with: resStationRoute)

            } onFailure: { error in
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
    }
    
    func createDataList(with list: [Rest.BusRouteInfo.ItemList]) {
        let newList = list.enumerated().map { index, itemList in
            DestinationTableData.stationResult(
                station: itemList,
                isLast: index == list.count - 1,
                nearestStationIndex: locationDataManager.nearestStationIndex)
        }
        output.tableData.onNext(newList)
    }
}

enum DestinationTableData {
    
    case searchResult(station: Rest.BusRouteInfo.ItemList, nextStation: String?)
    case stationResult(station: Rest.BusRouteInfo.ItemList, isLast: Bool, nearestStationIndex: Int)
}

