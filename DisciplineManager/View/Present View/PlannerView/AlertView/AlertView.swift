//
//  AlertView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class AlertView: UIView, View {
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - SelectedSwitch
    var alertState = false 
    
    // MARK: - ViewModel
    let alertViewModel = AlertViewModel()
    
    // MARK: - UI Components
    private let getAlertForThisTask: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "알림 받기"
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .disciplineBlue
        return switchControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        reactor = alertViewModel
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension AlertView: Bindable {
    func bind(reactor: AlertViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        switchControl.rx.isOn
            .map { AlertViewModel.Action.alertIsChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.alertStateIsChanged }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] switchIsToggled in
                self?.alertState = switchIsToggled
            })
            .disposed(by: disposeBag)
    }
}

extension AlertView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [getAlertForThisTask, switchControl].forEach { self.addSubview($0) }
        
        getAlertForThisTask.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.centerY.equalTo(switchControl.snp.centerY)
        }
        
        switchControl.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(self.snp.top).offset(20)
        }
    }
}
