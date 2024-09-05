//
//  BaseTableViewCell.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/4/24.
//

import UIKit
import RxSwift
//import RxCocoa

class BaseTableViewCell<T>: UITableViewCell {
    var disposeBag = DisposeBag()
    var reuseDisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        initConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
    func initView() {}
    func initConstraint() {}
    func bind() {}
    func configureCell(data: T?) {}
}
