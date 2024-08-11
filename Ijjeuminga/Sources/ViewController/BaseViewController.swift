//
//  BaseViewController.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewDisposeBag = DisposeBag()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDisposeBag = DisposeBag()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDisposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        initView()
        initConstraint()
        bindDataInDisposeBag()
    }
    
    func initView() {}
    
    func initConstraint() {}
    
    func bindDataInDisposeBag() {}
}

class ViewModelInjectionBaseViewController<T, T2: BaseViewModelOutput>: BaseViewController {
    var viewModel: T!

    init(viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.bindViewModelOutput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bind()
        if let viewModel = viewModel as? BaseViewModel<T2> {
            viewModel.attachView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let viewModel = viewModel as? BaseViewModel<T2> {
            viewModel.detachView()
        }
    }
    
    private func bindViewModelOutput() {
        guard let viewModel = self.viewModel as? BaseViewModel<T2> else {
            return
        }

        viewModel.output.presentVC
            .subscribe(onNext: { [weak self] (controller, animated) in
                self?.present(controller, animated: animated)
            })
            .disposed(by: disposeBag)
        viewModel.output.pushVC
            .subscribe(onNext: { [weak self] (controller, animated) in
                self?.navigationController?.pushViewController(controller, animated: animated)
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {}
}
