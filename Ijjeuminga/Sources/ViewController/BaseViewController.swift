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
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
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
    weak var indicator: UIActivityIndicatorView?
    
    init(viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.bindViewModelOutput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        view.addSubview(indicator)
        self.indicator = indicator
        
        indicator.setConstraintsToMatch(view)
        
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
        
        viewModel.output.error
            .subscribe(onNext: { (error, completion) in
                let closePopup = CustomAlertController()
                    .setTitleMessage(error.localizedDescription)
                    .addaction("닫기", .default) { _ in
                        guard let completion = completion else {
                            return
                        }
                        completion()
                    }
                    .setPreferredAction(action: .default)
                    .build()
                
                viewModel.output.presentVC.onNext((closePopup, true))
            })
            .disposed(by: disposeBag)
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
        viewModel.output.showIndicator
            .subscribe(onNext: { [weak self] show in
                if show {
                    self?.indicator?.startAnimating()
                } else {
                    self?.indicator?.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {}
}
