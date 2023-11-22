//
//  CalendarSheetController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/21.
//

import UIKit
import SnapKit
import FSCalendar
import ReactorKit
import RxCocoa

final class CalendarSheetController: UIViewController, UISheetPresentationControllerDelegate, View {
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - Data Receiver
    var selectedDate: Date?
    
    // MARK: - Delegate
    weak var delegate: DateSelectedDelegate?
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    // MARK: - UI Components
    private let calendar = FSCalendar()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold, scale: .large)
        let largeCloseImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)
        button.setImage(largeCloseImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("날짜 선택", for: .normal)
        button.titleLabel?.font = UIFont(name: "LINESeedSansKR-Bold", size: 18.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor = CalendarSheetViewModel()
        storePreviousSelectedDate()
    }
}

extension CalendarSheetController: Bindable {
    func bind(reactor: CalendarSheetViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        exitButton.rx.tap
            .map { CalendarSheetViewModel.Action.exitButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectButton.rx.tap
            .map { CalendarSheetViewModel.Action.selectButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.fullCalendarIsDismissed }
            .distinctUntilChanged()
            .subscribe { [weak self] value in
                if value {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.dateIsChanged }
            .distinctUntilChanged()
            .subscribe { [weak self] value in
                if value {
                    self?.moveToSelectedDate()
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToSelectedDate() {
        guard let date = selectedDate else { return }
        delegate?.dateSelected(date)
    }
}

extension CalendarSheetController: ViewDrawable {
    func configureUI() {
        setSheetPresentationController()
        setBackgroundColor()
        setAutolayout()
        setCalendarUI()
        setCalendarDelegate()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setAutolayout() {
        [exitButton, calendar, selectButton].forEach { view.addSubview($0) }
        
        exitButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.top.equalTo(view.snp.top).offset(20)
            make.width.height.equalTo(26)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.top.equalTo(exitButton.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(10)
        }
        
        selectButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - 나머지 UI 구현
    private func setSheetPresentationController() {
        sheetPresentationController.delegate = self
        sheetPresentationController.detents = [.medium()]
    }
    
    private func setCalendarUI() {
        setCalendarTextColor()
        hideCalendarText()
        setCalendarAsWeek()
        setCalendarFonts()
        setCalendarTextBackgroundColor()
    }
    
    private func setCalendarTextColor() {
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .systemPink
        calendar.appearance.headerTitleColor = .systemOrange
        calendar.appearance.weekdayTextColor = .orange
    }
    
    private func hideCalendarText() {
        hideCalendarHeaderSideText()
    }
    
    private func hideCalendarHeaderSideText() {
        calendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    
    private func setCalendarAsWeek() {
        calendar.scope = .month
    }
    
    private func setCalendarFonts() {
        calendar.appearance.titleFont = UIFont(name: "LINESeedSansKR-Bold", size: 15.0)
        calendar.appearance.weekdayFont = UIFont(name: "LINESeedSansKR-Regular", size: 15.0)
        calendar.appearance.headerTitleFont = UIFont(name: "LINESeedSansKR-Bold", size: 17.0)
    }
    
    private func setCalendarTextBackgroundColor() {
        calendar.appearance.todayColor = .systemOrange
        calendar.appearance.selectionColor = .systemPurple
    }
    
    private func storePreviousSelectedDate() {
        if let selectedDate = selectedDate {
            calendar.select(selectedDate)
        }
    }
    
    // MARK: - Delegate
    private func setCalendarDelegate() {
        calendar.delegate = self
    }
}

extension CalendarSheetController: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("CalendarSheet 선택된 날짜는 \(date)")
        self.selectedDate = date
        
        setTodayColorsIfOtherDateIsSelected()
        setSelectionColorOnTodayAndOtherDate(date: date)
    }
    
    private func setTodayColorsIfOtherDateIsSelected() {
        calendar.appearance.todayColor = .white
        calendar.appearance.titleTodayColor = .systemOrange
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            calendar.appearance.selectionColor = .systemOrange
        } else {
            calendar.appearance.selectionColor = .systemPurple
        }
    }
}
