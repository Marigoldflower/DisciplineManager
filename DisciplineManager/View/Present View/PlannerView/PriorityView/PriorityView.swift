//
//  PriorityView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class PriorityView: UIView, View {
    
    // MARK: - SelectedPriority
    var selectedPriority: String?
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - Data
    lazy var buttons: [UIButton] = [highButton, mediumButton, lowButton]
    
    // MARK: - ViewModel
    let priorityViewModel = PriorityViewModel()
    
    // MARK: - UI Components
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "중요도"
        return label
    }()
    
    let highButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplinePink.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("High", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    let mediumButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplineYellow.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("Medium", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    let lowButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplineBlue.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("Low", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    // MARK: - Stack
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highButton, mediumButton, lowButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reactor = priorityViewModel
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension PriorityView: Bindable {
    func bind(reactor: PriorityViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        highButton.rx.tap
            .map { PriorityViewModel.Action.highButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mediumButton.rx.tap
            .map { PriorityViewModel.Action.mediumButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        lowButton.rx.tap
            .map { PriorityViewModel.Action.lowButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.highButtonIsSelected }
            .subscribe(onNext: { [weak self] highButtonTapped in
                if highButtonTapped {
                    self?.setUnselectedButton()
                    self?.setSelectedButton(of: self!.highButton, with: .disciplinePink)
                    self?.setSelectedPriority(of: self!.highButton)
                }
            })
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.mediumButtonIsSelected }
            .subscribe(onNext: { [weak self] mediumButtonTapped in
                if mediumButtonTapped {
                    self?.setUnselectedButton()
                    self?.setSelectedButton(of: self!.mediumButton, with: .disciplineYellow)
                    self?.setSelectedPriority(of: self!.mediumButton)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lowButtonIsSelected }
            .subscribe(onNext: { [weak self] lowButtonTapped in
                if lowButtonTapped {
                    self?.setUnselectedButton()
                    self?.setSelectedButton(of: self!.lowButton, with: .disciplineBlue)
                    self?.setSelectedPriority(of: self!.lowButton)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUnselectedButton() {
        self.buttons.forEach {
            $0.backgroundColor = .disciplineBackground
            $0.setTitleColor(.disciplineBlack, for: .normal)
        }
    }
    
    private func setSelectedButton(of button: UIButton, with color: UIColor) {
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        
        UIView.animate(withDuration: 0.45) {
            button.alpha = 1
        }
    }
    
    private func setSelectedPriority(of button: UIButton) {
        self.selectedPriority = button.titleLabel?.text
    }
}

extension PriorityView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [priorityLabel, buttonStackView].forEach { self.addSubview($0) }
        
        priorityLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(priorityLabel.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
    }
}
