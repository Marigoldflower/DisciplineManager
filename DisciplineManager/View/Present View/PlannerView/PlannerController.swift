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
    
    private let howManyTimesToRepeatTheTask: HowManyTimesToRepeatTheTask = {
        let view = HowManyTimesToRepeatTheTask()
        return view
    }()
    
    let priorityView: PriorityView = {
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
        setTapGestures()
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
        sendTimeSettingViewStartTimetoPicker()
    }
    
    @objc func endTimeIsTapped() {
        if startTimePicker != nil {
            startTimePicker.removeFromSuperview()
            startTimePicker = nil
        }
        
        setEndTimePicker()
        sendTimeSettingViewEndTimetoPicker()
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
            make.width.equalTo(200)
            make.height.equalTo(175)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.startTimePicker.alpha = 1
        }
        
        startTimePicker.selectButton.addTarget(self, action: #selector(sendPickerStartTimetoTimeSettingView), for: .touchUpInside)
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
            make.width.equalTo(200)
            make.height.equalTo(175)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.endTimePicker.alpha = 1
        }
        
        endTimePicker.selectButton.addTarget(self, action: #selector(sendPickerEndTimetoTimeSettingView), for: .touchUpInside)
    }
    
    // TimeSettingView의 시작 시간을 StartPicker에 보내는 함수
    private func sendTimeSettingViewStartTimetoPicker() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "a hh:mm"
        
        guard let startTime = timeFormatter.date(from: self.timeSettingView.startTime) else { return }
        
        startTimePicker.startTimeReceiver = startTime
    }
    
    // TimeSettingView의 종료 시간을 EndPicker에 보내는 함수
    private func sendTimeSettingViewEndTimetoPicker() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "a hh:mm"
        
        guard let endTime = timeFormatter.date(from: self.timeSettingView.endTime) else { return }
        
        endTimePicker.endTimeReceiver = endTime
    }
    
    // StartPicker의 시작 시간을 TimeSettingView의 시작 시간에 보내는 함수
    @objc func sendPickerStartTimetoTimeSettingView() {
        let amPm = startTimePicker.selectedAmPm
        let hour = startTimePicker.selectedHour
        let minute = startTimePicker.selectedMinute
        let startTime = amPm + " " + hour + ":" + minute
        
        self.timeSettingView.startTime = startTime
        
        startTimePicker.removeFromSuperview()
        startTimePicker = nil
    }
    
    // EndPicker의 종료 시간을 TimeSettingView의 종료 시간에 보내는 함수
    @objc func sendPickerEndTimetoTimeSettingView() {
        let amPm = endTimePicker.selectedAmPm
        let hour = endTimePicker.selectedHour
        let minute = endTimePicker.selectedMinute
        let endTime = amPm + " " + hour + ":" + minute
        
        self.timeSettingView.endTime = endTime
        
        endTimePicker.removeFromSuperview()
        endTimePicker = nil
    }
}

extension PlannerController: Bindable {
    func bind(reactor: PlannerViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        priorityView.highButton.rx.tap
            .map { PlannerViewModel.Action.highButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priorityView.mediumButton.rx.tap
            .map { PlannerViewModel.Action.mediumButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priorityView.lowButton.rx.tap
            .map { PlannerViewModel.Action.lowButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.highButtonIsSelected }
            .subscribe(onNext: { [weak self] highButtonTapped in
                if highButtonTapped {
                    self?.priorityView.buttons.forEach {
                        $0.backgroundColor = .disciplineBackground
                        $0.setTitleColor(.disciplineBlack, for: .normal)
                    }
                    
                    self?.priorityView.highButton.backgroundColor = .disciplinePink
                    self?.priorityView.highButton.setTitleColor(.white, for: .normal)
                    self?.priorityView.highButton.alpha = 0
                    
                    UIView.animate(withDuration: 0.45) {
                        self?.priorityView.highButton.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.mediumButtonIsSelected }
            .subscribe(onNext: { [weak self] mediumButtonTapped in
                if mediumButtonTapped {
                    self?.priorityView.buttons.forEach {
                        $0.backgroundColor = .disciplineBackground
                        $0.setTitleColor(.disciplineBlack, for: .normal)
                    }
                    
                    self?.priorityView.mediumButton.backgroundColor = .disciplineYellow
                    self?.priorityView.mediumButton.setTitleColor(.white, for: .normal)
                    self?.priorityView.mediumButton.alpha = 0
                    
                    UIView.animate(withDuration: 0.45) {
                        self?.priorityView.mediumButton.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lowButtonIsSelected }
            .subscribe(onNext: { [weak self] lowButtonTapped in
                if lowButtonTapped {
                    self?.priorityView.buttons.forEach {
                        $0.backgroundColor = .disciplineBackground
                        $0.setTitleColor(.disciplineBlack, for: .normal)
                    }
                    
                    self?.priorityView.lowButton.backgroundColor = .disciplineBlue
                    self?.priorityView.lowButton.setTitleColor(.white, for: .normal)
                    self?.priorityView.lowButton.alpha = 0
                    
                    UIView.animate(withDuration: 0.45) {
                        self?.priorityView.lowButton.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
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
        [taskView, timeSettingView, howManyTimesToRepeatTheTask, priorityView, alertView, createPlanButton].forEach { view.addSubview($0) }
        
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
        
        howManyTimesToRepeatTheTask.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(timeSettingView.snp.bottom)
            make.height.equalTo(110)
        }
        
        priorityView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(howManyTimesToRepeatTheTask.snp.bottom)
            make.height.equalTo(110)
        }
        
        alertView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(priorityView.snp.bottom)
            make.height.equalTo(110)
        }
        
        createPlanButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(45)
        }
    }
    
    private func setPriorityButtonColor(buttonType: PriorityButtonType) {
        switch buttonType {
        case .high:
                
            priorityView.highButton.backgroundColor = .disciplinePink
            priorityView.highButton.setTitleColor(.white, for: .normal)
            
            priorityView.mediumButton.backgroundColor = .disciplineYellow
            priorityView.mediumButton.setTitleColor(.white, for: .normal)
            
            priorityView.lowButton.backgroundColor = .disciplineBlue
            priorityView.lowButton.setTitleColor(.white, for: .normal)
        case .medium:
            priorityView.mediumButton.backgroundColor = .disciplineYellow
            priorityView.mediumButton.setTitleColor(.white, for: .normal)
        case .low:
            priorityView.lowButton.backgroundColor = .disciplineBlue
            priorityView.lowButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func setSelectedButtonColorOnly(with buttonType: PriorityButtonType) {
        priorityView.highButton.backgroundColor = .disciplinePink
        priorityView.highButton.setTitleColor(.white, for: .normal)
    }
}
