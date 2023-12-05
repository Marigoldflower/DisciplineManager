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
        button.titleLabel?.font = UIFont(name: "LINESeedSansKR-Bold", size: 15.0)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    let setDateButton_ImageVersion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
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
        self.backgroundColor = .white
    }
    
    func setAutolayout() {
        [dateButtonStackView, calendar].forEach { self.addSubview($0) }
        
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
        calendar.appearance.titleWeekendColor = .disciplineRed
        calendar.appearance.weekdayTextColor = .orange
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
        calendar.appearance.titleFont = UIFont(name: "LINESeedSansKR-Bold", size: 15.0)
        calendar.appearance.weekdayFont = UIFont(name: "LINESeedSansKR-Regular", size: 15.0)
    }
    
    private func setCalendarTextBackgroundColor() {
        calendar.appearance.todayColor = .disciplineYellow
        calendar.appearance.selectionColor = .disciplineRed
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
        calendar.appearance.todayColor = .white
        calendar.appearance.titleTodayColor = .disciplineYellow
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            calendar.appearance.selectionColor = .disciplineYellow
        } else {
            calendar.appearance.selectionColor = .disciplineRed
        }
    }
}
