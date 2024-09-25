//
//  DepartureViewModel.swift
//  Common
//
//  Created by BH on 9/23/24.
//
import Common
import RxSwift

class DepartureViewModelInput: BaseViewModelInput {
    let didTapConfirm = PublishSubject<String>()
}

class DepartureViewModelOutput: BaseViewModelOutput {
    let busNumber = PublishSubject<String>()
    let busList = PublishSubject<([Rest.BusRouteInfo.ItemList], Bool)>()
    let close = PublishSubject<Void>()
}

final class DepartureViewModel: BaseViewModel<DepartureViewModelOutput> {
    
    let input = DepartureViewModelInput()
    
    private var currentPosIndex: Int = -1
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
        LocationDataManager.shared.requestLocationAuth()
        
        input.didTapConfirm
            .subscribe(onNext: { [weak self] seq in
                self?.routeToDestination(with: seq)
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
            .subscribe(onNext: { [weak self] (nearestIndex, secondNearIndex) in
                guard let self = self else { return }
                getBusList(index: nearestIndex, isNearest: true)
                getBusList(index: secondNearIndex, isNearest: false)
            }, onError: { error in
                print("\(#function), Error: \(error.localizedDescription)")
            })
            
            .disposed(by: viewDisposeBag)
    }
    
    private func getBusList(index: Int, isNearest: Bool) {
        let endIndex = min(index + 4, stationList.count)
        let range = index..<endIndex
        let busList = stationList[range]
        self.output.busList.onNext((Array(busList), isNearest))
    }
    
    private func routeToDestination(with seq: String) {
        let viewModel = DestinationViewModel(busType: self.busType,
                                             routeId: self.routeId,
                                             seq: seq)
        let controller = DestinationViewController(viewModel: viewModel)
        
        viewModel.output.close
            .bind(to: output.close)
            .disposed(by: disposeBag)
        
        output.pushVC.onNext((controller, true))
    }
}
