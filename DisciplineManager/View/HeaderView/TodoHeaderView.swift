//
//  CalendarCheckView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/22.
//

import UIKit
import FSCalendar
import SnapKit

protocol HeaderViewSelectedDateDelegate: AnyObject {
    func sendSelectedDate(date: Date)
}

final class TodoHeaderView: UIView {
    // MARK: - Data Receiver
    // CalendarController에서 선택한 날짜
    var dateWhichIsSentToCalendarController: Date? {
        didSet {
            delegate?.sendSelectedDate(date: dateWhichIsSentToCalendarController!)
        }
    }
    
    // HeaderView에서 특정 날짜를 선택했을 때 CalendarController에게 보낼 요소
    var selectedDate: Date? {
        didSet {
            delegate?.sendSelectedDate(date: selectedDate!)
        }
    }
    
    // MARK: - Delegate
    weak var delegate: HeaderViewSelectedDateDelegate?
    
    // MARK: - UI Components
    let calendar = FSCalendar()
    
    let setDateButton_TextVersion: UIButton = {
        let button = UIButton()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        let currentYearsAndMonths = formatter.string(from: Date())
        button.setTitle(currentYearsAndMonths, for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 15.0)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    let setDateButton_ImageVersion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let alertButton: UIButton = {
        let button = UIButton()
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .medium)
        let bellImage = UIImage(systemName: "bell", withConfiguration: buttonConfig)
        button.setImage(bellImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    // MARK: - StackView
    private lazy var dateButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [setDateButton_TextVersion, setDateButton_ImageVersion])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TodoHeaderView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setCalendarUI()
        setCalendarDelegate()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [dateButtonStackView, calendar, alertButton].forEach { self.addSubview($0) }
        
        dateButtonStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(dateButtonStackView.snp.bottom).offset(10)
            make.height.equalTo(240)
        }
        
        alertButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.centerY.equalTo(dateButtonStackView.snp.centerY)
        }
    }
    
    // MARK: - 나머지 UI 구현부
    private func setCalendarUI() {
        setCalendarTextColor()
        hideCalendarText()
        setCalendarAsWeek()
        setCalendarFonts()
        setCalendarTextBackgroundColor()
    }
    
    private func setCalendarTextColor() {
        calendar.appearance.titleDefaultColor = .disciplineBlack
        calendar.appearance.titleWeekendColor = .disciplinePurple
        calendar.appearance.weekdayTextColor = .disciplineBlack
    }
    
    private func hideCalendarText() {
        hideCalendarHeaderSideText()
        hideCalendarHeaderTitleText()
    }
    
    private func hideCalendarHeaderSideText() {
        calendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    
    private func hideCalendarHeaderTitleText() {
        calendar.headerHeight = 0
    }
    
    private func setCalendarAsWeek() {
        calendar.scope = .week
    }
    
    private func setCalendarFonts() {
        calendar.appearance.titleFont = .LINESeedRegular(size: 16.0)
        calendar.appearance.weekdayFont = .LINESeedRegular(size: 15.0)
    }
    
    private func setCalendarTextBackgroundColor() {
        calendar.appearance.todayColor = .disciplinePurple
        calendar.appearance.selectionColor = .disciplineBlue
    }
    
    // MARK: - Delegate
    private func setCalendarDelegate() {
        calendar.delegate = self
    }
}

extension TodoHeaderView: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("HeaderView에서 선택된 날짜는 \(date)")
        self.selectedDate = date
        
        setTodayColorsIfOtherDateIsSelected()
        setSelectionColorOnTodayAndOtherDate(date: date)
    }
    
    private func setTodayColorsIfOtherDateIsSelected() {
        calendar.appearance.todayColor = .disciplineBackground
        calendar.appearance.titleTodayColor = .disciplinePurple
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            calendar.appearance.selectionColor = .disciplinePurple
        } else {
            calendar.appearance.selectionColor = .disciplineBlue
        }
    }
}
