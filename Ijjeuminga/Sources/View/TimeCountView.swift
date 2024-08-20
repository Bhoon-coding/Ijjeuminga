//
//  TimeCountView.swift
//  Ijjeuminga
//
//  Created by hayeon on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

class TimeCountView: BaseReactiveView {
    
    struct Padding {
        private init() {}
        static let width: CGFloat = 48
    }
    
    struct Input {
        let startTimer = PublishSubject<Int>()
        let stopTimer = PublishSubject<Void>()
    }
    
    struct Output {
        let didTap = PublishSubject<Void>()
    }
    
    let input = Input()
    let output = Output()
    
    weak var containerView: UIView!
    weak var titleLabel: UILabel!
    weak var indicator: UIActivityIndicatorView!
    
    private var timerDisposeBag = DisposeBag()

    override func initView() {
        super.initView()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = UIColor.blueBus.cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = Padding.width / 2
        addSubview(containerView)
        self.containerView = containerView
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .blueBus
        titleLabel.text = "0"
        containerView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .blueBus
        containerView.addSubview(indicator)
        self.indicator = indicator
        
        containerView.setConstraintsToMatch(self)
        indicator.setConstraintsToMatch(containerView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: Padding.width),
            containerView.heightAnchor.constraint(equalToConstant: Padding.width),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    override func initEvent() {
        super.initEvent()
     
        let tapGesture = UITapGestureRecognizer()
        containerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.stopTimer()
            })
            .disposed(by: disposeBag)
        
        input.startTimer
            .subscribe(onNext: { [weak self] count in
                self?.startTimer(count)
            })
            .disposed(by: disposeBag)
        
        input.stopTimer
            .subscribe(onNext: { [weak self] count in
                self?.stopTimer()
            })
            .disposed(by: disposeBag)
    }
    
    private func startTimer(_ count: Int) {
        timerDisposeBag = DisposeBag()
        self.updateStartTimerUI(count: count)
        
        Observable<Int>.interval(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] time in
                guard time < 15 else {
                    self?.stopTimer()
                    return
                }
                
                self?.updateTimeText("\(count - time - 1)")
                
            })
            .disposed(by: timerDisposeBag)
        
    }
    
    private func updateTimeText(_ text: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = text
        }
    }
    
    private func stopTimer() {
        timerDisposeBag = DisposeBag()
        self.updateStopTimerUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.output.didTap.onNext(())
        }
    }
    
    private func updateStartTimerUI(count: Int) {
        Log.info("start \(Date())")
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            self.titleLabel.text = "\(count)"
            self.titleLabel.isHidden = false
            self.indicator.stopAnimating()
        }
    }
    
    private func updateStopTimerUI() {
        Log.info("stop \(Date())")
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            self.titleLabel.text = ""
            self.titleLabel.isHidden = true
            self.indicator.startAnimating()
        }
    }
}
