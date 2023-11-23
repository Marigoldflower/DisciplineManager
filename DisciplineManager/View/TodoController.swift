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
import RxRelay
import RxCocoa

protocol DateSelectedDelegate: AnyObject {
    func dateSelected(_ date: Date)
}

final class TodoController: UIViewController, View {
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - ViewModel
    let todoViewModel = TodoViewModel()
    
    // MARK: - UI Components
    private let todoHeaderView: TodoHeaderView = {
        let view = TodoHeaderView()
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
        getTodoList()
        reactor = TodoViewModel()
    }
    
    private func getTodoList() {
        todoViewModel.getTodoList()
        
        todoViewModel.todo.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: HomeCell.identifier, cellType: HomeCell.self)) { index, element, cell in
                cell.timeLabel.text = element.time
                cell.iconButton.setImage(element.iconImage, for: .normal)
                cell.whatToDo.setTitle(element.whatToDo, for: .normal)
            }
            .disposed(by: disposeBag)
        
        todoViewModel.todoObserver
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension TodoController: Bindable {
    func bind(reactor: TodoViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        todoHeaderView.setDateButton_TextVersion.rx.tap
            .map { TodoViewModel.Action.setDateButton_TextVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        todoHeaderView.setDateButton_ImageVersion.rx.tap
            .map { TodoViewModel.Action.setDateButton_ImageVersionTapped }
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
        calendarSheetController.selectedDate = todoHeaderView.selectedDate
        self.present(calendarSheetController, animated: true)
    }
}

extension TodoController: ViewDrawable {
    // MARK: - protocol 구현부
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setAutolayout() {
        [todoHeaderView, tableView].forEach { view.addSubview($0) }
        
        todoHeaderView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(110)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(todoHeaderView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension TodoController: DateSelectedDelegate {
    func dateSelected(_ date: Date) {
        todoHeaderView.calendar.setCurrentPage(date, animated: true)
        todoHeaderView.calendar.select(date)
        setTodayColorsIfOtherDateIsSelected()
        setSelectionColorOnTodayAndOtherDate(date: date)
    }
    
    private func setTodayColorsIfOtherDateIsSelected() {
        todoHeaderView.calendar.appearance.todayColor = .white
        todoHeaderView.calendar.appearance.titleTodayColor = .systemOrange
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            todoHeaderView.calendar.appearance.selectionColor = .systemOrange
        } else {
            todoHeaderView.calendar.appearance.selectionColor = .systemPurple
        }
    }
}
