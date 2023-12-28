//
//  PlannerController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/15.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class PlannerController: UIViewController, View {
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - ViewModel
    let plannerViewModel = PlannerViewModel()
    
    // MARK: - PresentView
    var customDatePickerController: CustomDatePickerController! = nil
    
    // MARK: - UI Components
    private let taskView: TaskView = {
        let view = TaskView()
        return view
    }()
    
    let timeSettingView: TimeSettingView = {
        let view = TimeSettingView()
        return view
    }()
    
    private let priorityView: PriorityView = {
        let view = PriorityView()
        return view
    }()
    
    private let alertView: AlertView = {
        let view = AlertView()
        return view
    }()
    
    private let createPlanButton: UIButton = {
        let button = UIButton()
        button.setTitle("할 일 생성", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 18.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .disciplinePurple
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskView, timeSettingView, priorityView, alertView])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = plannerViewModel
        configureUI()
    }
}

extension PlannerController: Bindable {
    func bind(reactor: PlannerViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        timeSettingView.startDatePicker.rx.tap
            .map { PlannerViewModel.Action.timeSelectButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSettingView.endDatePicker.rx.tap
            .map { PlannerViewModel.Action.timeSelectButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.datePickerIsPresented }
            .subscribe(onNext: { [weak self] timeSelectButtonTapped in
                if timeSelectButtonTapped {
                    print("Time Select Button이 클릭되었습니다.")
                    self?.presentCustomDatePickerController()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func presentCustomDatePickerController() {
        customDatePickerController = CustomDatePickerController()
        present(customDatePickerController, animated: true)
    }
}


extension PlannerController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [taskView, timeSettingView, priorityView, alertView, createPlanButton].forEach { view.addSubview($0) }
        
        taskView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(120)
        }
        
        timeSettingView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(taskView.snp.bottom)
            make.height.equalTo(110)
        }
        
        createPlanButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(45)
        }
    }
}

