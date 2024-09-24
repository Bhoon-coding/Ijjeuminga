//
//  DeparatureViewModel.swift
//  Common
//
//  Created by BH on 9/23/24.
//
import Common
//import UIKit
import RxSwift

class DeparatureViewModelInput: BaseViewModelInput {
    
}

class DepartureViewModelOutput: BaseViewModelOutput {
    let busNumber = PublishSubject<String>()
    let close = PublishSubject<Void>()
}

final class DepartureViewModel: BaseViewModel<DepartureViewModelOutput> {
    
    let input = DeparatureViewModelInput()
    
    private var stationList: [Rest.BusRouteInfo.ItemList] = [] {
        didSet {
            if let busNumber = stationList.first?.busRouteAbrv {
                output.busNumber.onNext(busNumber)
            }
        }
    }
    private let routeId: String
    let busType: KoreaBusType.RawValue
    
    init(routeId: String, busType: KoreaBusType.RawValue) {
        self.routeId = routeId
        self.busType = busType
    }
    
    override func attachView() {
        fetchStationByRoute(with: self.routeId)
    }
    
    private func fetchStationByRoute(with routeId: String) {
        BusRouteInfoAPIService()
            .getStaionByRoute(with: routeId)
            .subscribe { [weak self] res in
                guard let stationList = res.msgBody.itemList else { return }
                self?.stationList = stationList
                self?.getCurrentPosition(stationList: stationList)
            } onFailure: { [weak self] error in
                self?.output.error.onNext((error, {
                    self?.output.close.onNext(())
                }))
                print("error: \(error.localizedDescription)")

            }
            .disposed(by: disposeBag)
    }
    
    private func getCurrentPosition(stationList: [Rest.BusRouteInfo.ItemList]) {
        LocationDataManager.shared.compareLocation(to: stationList)
            .subscribe { [weak self] nearestIndex in
                guard let self = self else { return }
                // TODO: [] 가장 가까운 정류장 두 리스트 정보 가져오기
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func openBusStopList(routeId: String, busType: KoreaBusType.RawValue) {
        let viewModel = DestinationViewModel(routeId: routeId, busType: busType)
        let controller = DestinationViewController(viewModel: viewModel)
        viewModel.output.close
            .bind(to: output.close)
            .disposed(by: disposeBag)
        output.pushVC.onNext((controller, true))
    }
}
