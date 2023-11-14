//
//  ViewController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/07.
//

import UIKit
import FSCalendar
import SnapKit
import ReactorKit
import RxCocoa

final class HomeController: UIViewController, View {
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let calendar = FSCalendar()
    
    private let setDateButton_TextVersion: UIButton = {
        let button = UIButton()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        let currentYearsAndMonths = formatter.string(from: Date())
        button.setTitle(currentYearsAndMonths, for: .normal)
        button.titleLabel?.font = UIFont(name: "LINESeedSansKR-Bold", size: 15.0)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    private let setDateButton_ImageVersion: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor = HomeControllerViewModel()
    }
}

extension HomeController: Bindable {
    func bind(reactor: HomeControllerViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        setDateButton_TextVersion.rx.tap
            .map { HomeControllerViewModel.Action.setDateButton_TextVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        setDateButton_ImageVersion.rx.tap
            .map { HomeControllerViewModel.Action.setDateButton_ImageVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.isFullCalendarShown }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe { [weak self] value in
                if value {
                    self?.presentFullCalendar()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func presentFullCalendar() {
        let customFullCalendarView: CustomFullCalendarView = {
            let view = CustomFullCalendarView()
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            return view
        }()
        
        self.view.addSubview(customFullCalendarView)
        
        customFullCalendarView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(self.view.frame.height / 2)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.systemGray4
        }
        
        UIView.animate(withDuration: 0.5) {
            customFullCalendarView.snp.makeConstraints { make in
                make.leading.equalTo(self.view.snp.leading).offset(10)
                make.trailing.equalTo(self.view.snp.trailing).offset(-10)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
                make.height.equalTo(self.view.frame.height / 2)
            }
        }
    }
    
    
}

extension HomeController: ViewDrawable {
    // MARK: - protocol 구현부
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setCalendarUI()
        setCalendarDelegate()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setAutolayout() {
        [dateButtonStackView, calendar].forEach { view.addSubview($0) }
        
        dateButtonStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
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
    }
    
    private func setCalendarTextColor() {
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .systemPink
        calendar.appearance.headerTitleColor = .systemPink
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
    
    // MARK: - delegate 구현부
    private func setCalendarDelegate() {
        calendar.delegate = self
        calendar.dataSource = self
    }
    
}

extension HomeController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
}

