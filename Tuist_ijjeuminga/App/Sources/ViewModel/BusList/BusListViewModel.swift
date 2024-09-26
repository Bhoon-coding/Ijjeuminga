//
//  BusListViewModel.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 6/16/24.
//

import Common
import Foundation
import UIKit

import RxSwift

class BusListViewModelInput: BaseViewModelInput {
    let searchedText = PublishSubject<String>()
    let selectBus = PublishSubject<(String, KoreaBusType.RawValue)>()
}

class BusListViewModelOutput: BaseViewModelOutput {
    let searchedBusList = PublishSubject<[BusInfo]>()
    let recentBusList = PublishSubject<[RecentBusInfo]>()
    let close = PublishSubject<Void>()
}

class BusListViewModel: BaseViewModel<BusListViewModelOutput> {
    
    let input = BusListViewModelInput()
    private var busList = [BusInfo]()
    private var searchedBusList = [BusInfo]()
    
    override func attachView() {
        self.getBusTotalList()
        self.getRecentSearchBusList()
        self.getSearchedBusList()
        
        input.selectBus
            .subscribe { [weak self] (routeId, busType) in
                self?.routeDepartureVC(routeId: routeId, busType: busType)
            }
            .disposed(by: viewDisposeBag)
    }
    
    private func getBusTotalList() {
        let xlsx = OpenXlsx()
        self.busList = xlsx.openXlsx() ?? []
    }
    
    private func getRecentSearchBusList() {
        let recentSearchBusList = CoreDataManager.shared.getBusList()
        self.output.recentBusList.onNext(recentSearchBusList)
    }
    
    private func getSearchedBusList() {
        self.input.searchedText
            .subscribe { busNumber in
                self.searchedBusList = []
                for bus in self.busList {
                    if bus.busNumber.contains(busNumber.element ?? "") {
                        self.searchedBusList.append(bus)
                    }
                }
                self.output.searchedBusList.onNext(self.searchedBusList)
            }.disposed(by: viewDisposeBag)
    }
    
    private func routeDepartureVC(routeId: String, busType: KoreaBusType.RawValue) {
        let viewModel = DepartureViewModel(routeId: routeId, busType: busType)
        let controller = DepartureViewController(viewModel: viewModel)
        
        viewModel.output.close
            .bind(to: output.close)
            .disposed(by: disposeBag)
        output.pushVC.onNext((controller, true))
    }
}
