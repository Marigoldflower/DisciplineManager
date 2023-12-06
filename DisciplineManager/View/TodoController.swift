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
    
    // MARK: - Data Sender & Receiver
    var selectedDate: Date?
    
    // MARK: - UI Components
    private let todoHeaderView: TodoHeaderView = {
        let view = TodoHeaderView()
        return view
    }()
    
    private let todoList_Label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "LINESeedSansKR-Bold", size: 21.0)
        label.textColor = .disciplineBlack
        label.text = "TODO LIST"
        return label
    }()
    
    private let toDoList: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.disciplinePurple.cgColor
        view.layer.borderWidth = 2
//        view.backgroundColor = .disciplinePurple
        view.layer.cornerRadius = 20
        view.backgroundColor = .disciplineBackground
        view.layer.masksToBounds = true
        return view
    }()
    
    var calendarSheetController: CalendarSheetController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor = TodoViewModel()
        getTodoList()
    }
    
    private func getTodoList() {
        todoViewModel.getTodoList()
        
        
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
        calendarSheetController = CalendarSheetController()
        calendarSheetController.delegate = self // DateSelectedDelegate가 작동하게 하기 위한 위임자
        todoHeaderView.delegate = self // HeaderViewSelectedDateDelegate가 작동하게 하기 위한 위임자
        calendarSheetController.sharedDateWithHeaderView = selectedDate
        self.present(calendarSheetController, animated: true)
    }
    
    private func sendSelectedDateFromTodoHeaderViewToCalendarSheet(date: Date) {
        calendarSheetController.sharedDateWithHeaderView = date
    }
}

extension TodoController: ViewDrawable {
    // MARK: - protocol 구현부
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [todoHeaderView, todoList_Label, toDoList].forEach { view.addSubview($0) }
        
        todoHeaderView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(110)
        }
        
        todoList_Label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(todoHeaderView.snp.bottom).offset(20)
//            make.height.equalTo(110)
        }
        
        toDoList.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.top.equalTo(todoList_Label.snp.bottom).offset(20)
            make.height.equalTo(110)
        }
    }
}

// CalendarController로부터 받은 Date값을 HeaderView에게 넘겨주는 역할 ⭐️
extension TodoController: DateSelectedDelegate {
    func dateSelected(_ date: Date) {
        todoHeaderView.dateWhichIsSentToCalendarController = date
        todoHeaderView.calendar.select(date)
        setTodayColorsIfOtherDateIsSelected()
        setSelectionColorOnTodayAndOtherDate(date: date)
    }
    
    private func setTodayColorsIfOtherDateIsSelected() {
        todoHeaderView.calendar.appearance.todayColor = .white
        todoHeaderView.calendar.appearance.titleTodayColor = .disciplineBlue
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            todoHeaderView.calendar.appearance.selectionColor = .disciplineBlue
        } else {
            todoHeaderView.calendar.appearance.selectionColor = .disciplinePink
        }
    }
}

// HeaderView로부터 받은 Date 값을 CalendarController에게 넘겨주는 역할 ⭐️
extension TodoController: HeaderViewSelectedDateDelegate {
    func sendSelectedDate(date: Date) {
        self.selectedDate = date
    }
}
