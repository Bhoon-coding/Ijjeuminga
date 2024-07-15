//
//  BaseViewModel.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModelInput {

}

class BaseViewModelOutput {
    required init() {}
    let error = PublishSubject<(Error, (() -> Void)?)>()
    let pushVC = PublishSubject<(UIViewController, Bool)>()
    let presentVC = PublishSubject<(UIViewController, Bool)>()
    let showSpinner = PublishSubject<Bool>()
}

class BaseViewModel<T: BaseViewModelOutput> {
    var disposeBag = DisposeBag()
    var viewDisposeBag = DisposeBag()

    let output = T()

    func attachView() {
        viewDisposeBag = DisposeBag()
    }

    func detachView() {
        viewDisposeBag = DisposeBag()
    }

}
