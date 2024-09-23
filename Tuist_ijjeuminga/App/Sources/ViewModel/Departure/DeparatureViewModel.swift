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
    
}

final class DeparatureViewModel: BaseViewModel<DepartureViewModelOutput> {
    
    let input = DeparatureViewModelInput()
    
    private let routeId: String
    let busType: KoreaBusType.RawValue
    
    init(routeId: String, busType: KoreaBusType.RawValue) {
        self.routeId = routeId
        self.busType = busType
    }
    
    override func attachView() {
        
    }
}
