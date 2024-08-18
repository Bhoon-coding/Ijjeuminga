//
//  BaseView.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/11/24.
//

import UIKit.UIView
import RxSwift

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
    
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {}
}

class BaseReactiveView: BaseView {
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        initEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initEvent() {}
}
