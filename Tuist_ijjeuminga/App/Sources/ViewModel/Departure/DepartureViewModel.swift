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
    let close = PublishSubject<Void>()
}

final class DepartureViewModel: BaseViewModel<DepartureViewModelOutput> {
    
    let input = DeparatureViewModelInput()
    
    private let routeId: String
    let busType: KoreaBusType.RawValue
    
    init(routeId: String, busType: KoreaBusType.RawValue) {
        self.routeId = routeId
        self.busType = busType
    }
    
    override func attachView() {
        
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
