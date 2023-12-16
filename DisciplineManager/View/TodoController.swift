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
        label.font = .LINESeedRegular(size: 21.0)
        label.textColor = .disciplineBlack
        label.text = "할 일 리스트"
        return label
    }()
    
    private lazy var todoListTableView: UITableView = {
        let table = UITableView()
        table.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.identifier)
        table.backgroundColor = .disciplineBackground
        table.separatorStyle = .none
        table.delegate = self
        return table
    }()
    
    private let addTodoListButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeCloseImage = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
        button.setImage(largeCloseImage, for: .normal)
        button.tintColor = .disciplineBlue
        return button
    }()
    
    // MARK: - PresentView
    var calendarSheetController: CalendarSheetController! = nil
    var plannerController: PlannerController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor = TodoViewModel()
        getTodoList()
    }
    
    private func getTodoList() {
        todoViewModel.getTodoList()
        
        todoViewModel.todo
            .asDriver(onErrorJustReturn: [])
            .drive(self.todoListTableView.rx.items(cellIdentifier: ToDoListCell.identifier, cellType: ToDoListCell.self)) { index, element, cell in
                cell.selectionStyle = .none
                cell.toDoListView.time.text = element.time
                cell.toDoListView.whatToDo.text = element.whatToDo
            }
            .disposed(by: disposeBag)
        
        todoViewModel.todoObserver
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                self?.todoListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension TodoController: Bindable {
    func bind(reactor: TodoViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        // MARK: - HeaderView Binding
        todoHeaderView.setDateButton_TextVersion.rx.tap
            .map { TodoViewModel.Action.setDateButton_TextVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        todoHeaderView.setDateButton_ImageVersion.rx.tap
            .map { TodoViewModel.Action.setDateButton_ImageVersionTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - AddTodoList Button Binding
        addTodoListButton.rx.tap
            .map { TodoViewModel.Action.addTodoListButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        // MARK: - HeaderView State
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
        
        // MARK: - AddTodoList Button State
        reactor.state
            .map { $0.isPlannerShown }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe { [weak self] value in
                if value {
                    self?.presentPlanner()
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
    
    // 오늘 하루 계획을 짜는 뷰를 띄우기 (여기서부터 진행)
    private func presentPlanner() {
        plannerController = PlannerController()
        setNavigationTitleAndButton(at: plannerController)
        setNavigationController(appearance: customNavigationBar())
    }
    
    private func customNavigationBar() -> UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .disciplinePurple // UINavigationBar의 bar 색상 설정
        navigationBarAppearance.titleTextAttributes = [
            .font: UIFont.LINESeedRegular(size: 17) as Any, // 텍스트 폰트 설정
            .foregroundColor: UIColor.white // 텍스트 색상 설정
        ]
        return navigationBarAppearance
    }
    
    private func setNavigationController(appearance: UINavigationBarAppearance) {
        let navigation = UINavigationController(rootViewController: plannerController)
        navigation.modalPresentationStyle = .fullScreen
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.scrollEdgeAppearance = appearance
        present(navigation, animated: true)
    }
    
    private func setNavigationTitleAndButton(at view: PlannerController) {
        view.navigationItem.title = "할 일 생성"
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold, scale: .large)
        let largeCloseImage = UIImage(systemName: "x.circle.fill", withConfiguration: largeConfig)
        let rightButton = UIBarButtonItem(image: largeCloseImage, style: .plain, target: self, action: #selector(rightButtonAction))
        rightButton.tintColor = .white
        view.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func rightButtonAction() {
        self.dismiss(animated: true)
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
        [todoHeaderView, todoList_Label, addTodoListButton, todoListTableView].forEach { view.addSubview($0) }
        
        todoHeaderView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(110)
        }
        
        todoList_Label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(todoHeaderView.snp.bottom).offset(20)
        }
        
        addTodoListButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.centerY.equalTo(todoList_Label.snp.centerY)
        }
        
        todoListTableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(todoList_Label.snp.bottom).offset(20)
            make.bottom.equalTo(view.snp.bottom)
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
        todoHeaderView.calendar.appearance.titleTodayColor = .disciplinePurple
    }
    
    private func setSelectionColorOnTodayAndOtherDate(date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            todoHeaderView.calendar.appearance.selectionColor = .disciplinePurple
        } else {
            todoHeaderView.calendar.appearance.selectionColor = .disciplineBlue
        }
    }
}

// HeaderView로부터 받은 Date 값을 CalendarController에게 넘겨주는 역할 ⭐️
extension TodoController: HeaderViewSelectedDateDelegate {
    func sendSelectedDate(date: Date) {
        self.selectedDate = date
    }
}

extension TodoController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        return setCellSwipeDeleteConfiguration(tableView: tableView, indexPath: indexPath)
    }
    
    private func setCellSwipeDeleteConfiguration(tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            //                UserDefaults.standard.userDataList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //                self.userDefaultsCount -= 1
            completionHandler(true)
        }
        let pointConfiguration = UIImage.SymbolConfiguration(pointSize: 13.5)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: pointConfiguration)
        deleteAction.backgroundColor = .disciplineGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

