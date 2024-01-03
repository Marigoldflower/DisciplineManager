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
    // MARK: - Tap Gestures
    lazy var startTapGestures = UITapGestureRecognizer(target: self, action: #selector(startTimeIsTapped))
    lazy var endTapGestures = UITapGestureRecognizer(target: self, action: #selector(endTimeIsTapped))
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - ViewModel
    let plannerViewModel = PlannerViewModel()
    
    // MARK: - PresentView
    var startTimePicker: TimePickerView! = nil
    var endTimePicker: TimePickerView! = nil
    
    // MARK: - UI Components
    private let taskView: TaskView = {
        let view = TaskView()
        return view
    }()
    
    lazy var timeSettingView: TimeSettingView = {
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
        setTapGestures()
        reactor = plannerViewModel
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if startTimePicker != nil {
            if touch != startTimePicker {
                startTimePicker.removeFromSuperview()
                startTimePicker = nil
            }
        }
        
        if endTimePicker != nil {
            if touch != endTimePicker {
                endTimePicker.removeFromSuperview()
                endTimePicker = nil
            }
        }
    }
    
    private func setTapGestures() {
        timeSettingView.startDateButton.addGestureRecognizer(startTapGestures)
        timeSettingView.endDateButton.addGestureRecognizer(endTapGestures)
        
    }
    
    // MARK: - objc
    @objc func startTimeIsTapped() {
        if endTimePicker != nil {
            endTimePicker.removeFromSuperview()
            endTimePicker = nil
        }
        
        setStartTimePicker()
        sendStartTimeToPicker()
        
    }
    
    @objc func endTimeIsTapped() {
        if startTimePicker != nil {
            startTimePicker.removeFromSuperview()
            startTimePicker = nil
        }
        
        setEndTimePicker()
        sendEndTimeToPicker()
    }
    
    private func setStartTimePicker() {
        startTimePicker = TimePickerView()
        startTimePicker.layer.cornerRadius = 15
        startTimePicker.layer.masksToBounds = true
        startTimePicker.alpha = 0

        [startTimePicker].forEach { view.addSubview($0) }
        
        startTimePicker.snp.makeConstraints { make in
            make.leading.equalTo(timeSettingView.startDateButton.snp.leading)
            make.top.equalTo(timeSettingView.snp.bottom)
            make.width.equalTo(160)
            make.height.equalTo(130)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.startTimePicker.alpha = 1
        }
    }
    
    private func setEndTimePicker() {
        endTimePicker = TimePickerView()
        endTimePicker.layer.cornerRadius = 15
        endTimePicker.layer.masksToBounds = true
        endTimePicker.alpha = 0
        
        [endTimePicker].forEach { view.addSubview($0) }
        
        endTimePicker.snp.makeConstraints { make in
            make.trailing.equalTo(timeSettingView.endDateButton.snp.trailing)
            make.top.equalTo(timeSettingView.snp.bottom)
            make.width.equalTo(160)
            make.height.equalTo(130)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.endTimePicker.alpha = 1
        }
    }
    
    private func sendStartTimeToPicker() {
        let currentTime = Date()
        startTimePicker.startTime = currentTime
    }
    
    private func sendEndTimeToPicker() {
        guard let threeHoursLater = Calendar.current.date(byAdding: .hour, value: 3, to: Date()) else { return }
        endTimePicker.endTime = threeHoursLater
    }
}

extension PlannerController: Bindable {
    func bind(reactor: PlannerViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        
    }
    
    func bindState(_ reactor: Reactor) {
        
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
