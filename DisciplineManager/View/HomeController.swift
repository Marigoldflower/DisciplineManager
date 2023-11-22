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

protocol DateSelectedDelegate: AnyObject {
    func dateSelected(_ date: Date)
}

final class HomeController: UIViewController, View {
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let homeHeaderView: HomeHeaderView = {
        let view = HomeHeaderView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        return table
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
        homeHeaderView.setDateButton_TextVersion.rx.tap
            .map { HomeControllerViewModel.Action.setDateButton_TextVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeHeaderView.setDateButton_ImageVersion.rx.tap
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
        let calendarSheetController = CalendarSheetController()
        calendarSheetController.delegate = self
        calendarSheetController.selectedDate = homeHeaderView.selectedDate
        self.present(calendarSheetController, animated: true)
    }
    
    
}

extension HomeController: ViewDrawable {
    // MARK: - protocol 구현부
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setAutolayout() {
        [homeHeaderView, tableView].forEach { view.addSubview($0) }
        
        homeHeaderView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(homeHeaderView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension HomeController: DateSelectedDelegate {
    func dateSelected(_ date: Date) {
        homeHeaderView.calendar.setCurrentPage(date, animated: true)
        homeHeaderView.calendar.select(date)
        setTodayColorsIfOtherDateIsSelected()
        setSelectionColorOnTodayAndOtherDate(date: date)
    }
    
    private func setTodayColorsIfOtherDateIsSelected() {
        homeHeaderView.calendar.appearance.todayColor = .white
        homeHeaderView.calendar.appearance.titleTodayColor = .systemOrange
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            homeHeaderView.calendar.appearance.selectionColor = .systemOrange
        } else {
            homeHeaderView.calendar.appearance.selectionColor = .systemPurple
        }
    }
}
