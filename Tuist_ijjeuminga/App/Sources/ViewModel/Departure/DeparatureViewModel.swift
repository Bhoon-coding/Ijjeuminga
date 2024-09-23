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
    
    public let busType: KoreaBusType.RawValue
    
    init(busType: KoreaBusType.RawValue) {
        self.busType = busType
    }
    
    override func attachView() {
        
    }
}
