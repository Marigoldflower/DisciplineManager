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

protocol SendPlanDelegate: AnyObject {
    func sendPlan(_ plan: String)
    func sendDetailPlan(_ plan: String)
    func sendTime(start: String, end: String)
    func sendHowManyTimesToRepeat(_ repetition: String)
    func sendPriority(_ priority: String)
    func sendAlert(with state: Bool)
}


final class PlannerController: UIViewController, View {
    // MARK: - Tap Gestures
    lazy var startTapGestures = UITapGestureRecognizer(target: self, action: #selector(startTimeIsTapped))
    lazy var endTapGestures = UITapGestureRecognizer(target: self, action: #selector(endTimeIsTapped))
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - Delegate
    weak var delegate: SendPlanDelegate?
    
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
        setStartTimePickerUI()
        setStartTimePickerAutoLayout()
        setStartTimePickerAnimate()
        setStartTimePickerButtonAction()
    }
    
    private func setStartTimePickerUI() {
        startTimePicker = TimePickerView()
        startTimePicker.layer.cornerRadius = 15
        startTimePicker.layer.masksToBounds = true
    }
    
    private func setStartTimePickerAutoLayout() {
        [startTimePicker].forEach { view.addSubview($0) }
        
        startTimePicker.snp.makeConstraints { make in
            make.leading.equalTo(timeSettingView.startDateButton.snp.leading)
            make.top.equalTo(timeSettingView.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(175)
        }
    }
    
    private func setStartTimePickerAnimate() {
        startTimePicker.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.startTimePicker.alpha = 1
        }
    }
    
    private func setStartTimePickerButtonAction() {
        startTimePicker.selectButton.addTarget(self, action: #selector(sendPickerStartTimetoTimeSettingView), for: .touchUpInside)
    }
    
    private func setEndTimePicker() {
        setEndTimePickerUI()
        setEndTimePickerAutoLayout()
        setEndTimePickerAnimate()
        setEndTimePickerButtonAction()
    }
    
    private func setEndTimePickerUI() {
        endTimePicker = TimePickerView()
        endTimePicker.layer.cornerRadius = 15
        endTimePicker.layer.masksToBounds = true
    }
    
    private func setEndTimePickerAutoLayout() {
        [endTimePicker].forEach { view.addSubview($0) }
        
        endTimePicker.snp.makeConstraints { make in
            make.trailing.equalTo(timeSettingView.endDateButton.snp.trailing)
            make.top.equalTo(timeSettingView.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(175)
        }
    }
    
    private func setEndTimePickerAnimate() {
        endTimePicker.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.endTimePicker.alpha = 1
        }
    }
    
    private func setEndTimePickerButtonAction() {
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
        createPlanButton.rx.tap
            .map { PlannerViewModel.Action.createPlanButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.receivedPlan }
            .subscribe(onNext: { [weak self] createPlanButtonTapped in
                if createPlanButtonTapped {
                    self?.sendTotalPlanToTodoController()
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func sendTotalPlanToTodoController() {
        sendPlan()
        sendDetailPlan()
        sendStartTimeAndEndTime()
        sendRepetition()
        sendPriority()
        sendAlertState()
    }
    
    private func sendPlan() {
        guard let plan = taskView.taskTextField.text else { return }
        delegate?.sendPlan(plan)
    }
    
    private func sendDetailPlan() {
        guard let detailPlan = taskView.detailTaskTextView.text else { return }
        delegate?.sendDetailPlan(detailPlan)
    }
    
    private func sendStartTimeAndEndTime() {
        let startTime = timeSettingView.startTime
        let endTime = timeSettingView.endTime
        
        delegate?.sendTime(start: startTime, end: endTime)
    }
    
    private func sendRepetition() {
        let repetition = howManyTimesToRepeatTheTask.selectedRepetition
        delegate?.sendHowManyTimesToRepeat(repetition)
    }
    
    private func sendPriority() {
        guard let priority = priorityView.selectedPriority else { return }
        delegate?.sendPriority(priority)
    }
    
    private func sendAlertState() {
        let alertState = alertView.alertState
        delegate?.sendAlert(with: alertState)
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
            make.height.equalTo(240)
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
}
