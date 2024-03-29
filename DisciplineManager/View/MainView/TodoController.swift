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
    
    // MARK: - Selected Plan Data
    var plan = String()
    var detailPlan = String()
    var startTime = String()
    var endTime = String()
    var repetition = String()
    var priorityColor = UIColor.clear
    var alertIsOn = false {
        didSet {
            newPlan = TodoModel(plan: plan, detailPlan: detailPlan, time: startTime + " - " + endTime, repetition: repetition, priorityColor: priorityColor, alertIsOn: alertIsOn)
        }
    }
    
    // MARK: - New Plan
    var newPlan: TodoModel = TodoModel(plan: String(), detailPlan: String(), time: String(), repetition: String(), priorityColor: UIColor.clear, alertIsOn: false) {
        didSet {
            print("새로 들어온 newPlan은 \(newPlan)")
            makePlan(with: newPlan)
            // 메소드로 만들어서 처리할 게 아니라 ViewModel에 있는
        }
    }
    
    // MARK: - UI Components
    private let detailMemoController = DetailMemoController()
    
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
        table.rowHeight = UITableView.automaticDimension
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
            .drive(self.todoListTableView.rx.items(cellIdentifier: ToDoListCell.identifier, cellType: ToDoListCell.self)) { [weak self] index, element, cell in
                cell.selectionStyle = .none
                self?.setTimeTo(cell: cell, with: element)
                self?.setPlanTo(cell: cell, with: element)
                self?.setDetailPlanTo(cell: cell, with: element)
                self?.setPriorityColorViewTo(cell: cell, with: element)
            }
            .disposed(by: disposeBag)
        
        todoViewModel.todoObserver
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                self?.todoListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setTimeTo(cell: ToDoListCell, with element: TodoModel) {
        cell.toDoListView.time.text = element.time
    }
    
    private func setPlanTo(cell: ToDoListCell, with element: TodoModel) {
        cell.toDoListView.plan.text = element.plan
    }
    
    private func setDetailPlanTo(cell: ToDoListCell, with element: TodoModel) {
        if element.detailPlan.count != 0 {
            makeDetailMemoButton(cell: cell)
            sendValueToDetailMemo(with: element)
        }
    }
    
    private func sendValueToDetailMemo(with element: TodoModel) {
        detailMemoController.detailMemoView.plan.text = element.plan
        detailMemoController.detailMemoView.detailPlan.text = element.detailPlan
    }
    
    private func makeDetailMemoButton(cell: ToDoListCell) {
        makeDetailMemoButtonImage(in: cell)
        setAutolayoutToDetailMemoButton(in: cell)
        setDetailMemoButtonAction(in: cell)
    }
    
    private func makeDetailMemoButtonImage(in cell: ToDoListCell) {
        cell.toDoListView.detailMemoButton = UIButton()
        cell.toDoListView.detailMemoButton.tintColor = .systemGray
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .default)
        let documentImage = UIImage(systemName: "doc.text", withConfiguration: buttonConfig)
        cell.toDoListView.detailMemoButton.setImage(documentImage, for: .normal)
    }
    
    private func setAutolayoutToDetailMemoButton(in cell: ToDoListCell) {
        [cell.toDoListView.detailMemoButton].forEach { cell.addSubview($0) }
        
        cell.toDoListView.detailMemoButton.snp.makeConstraints { make in
            make.trailing.equalTo(cell.toDoListView.priorityColorView.snp.leading).offset(-30)
            make.centerY.equalTo(cell.snp.centerY)
            make.width.equalTo(25)
            make.height.equalTo(30)
        }
    }
    
    private func setDetailMemoButtonAction(in cell: ToDoListCell) {
        cell.toDoListView.detailMemoButton.addTarget(self, action: #selector(detailMemoButtonTapped), for: .touchUpInside)
    }
    
    private func setPriorityColorViewTo(cell: ToDoListCell, with element: TodoModel) {
        cell.toDoListView.priorityColorView.backgroundColor = element.priorityColor
    }
    
    // 새로운 Plan을 만들 때, 시간 순서에 따라서 TodoModel 배열의 순서를 정해야 함 ⭐️
    private func makePlan(with newPlan: TodoModel) {
        todoViewModel.todoList.append(newPlan)
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "a hh:mm"
        //
        //        todoViewModel.todoList.sort { dateFormatter.date(from: $0.plan)! < dateFormatter.date(from: $1.plan)! }
        
        todoViewModel.getTodoList()
    }
    
    // MARK: - @objc
    @objc func detailMemoButtonTapped() {
        presentDetailMemoController()
    }
    
    private func presentDetailMemoController() {
        detailMemoController.modalPresentationStyle = .overCurrentContext
        detailMemoController.modalTransitionStyle = .crossDissolve
        self.present(detailMemoController, animated: true, completion: nil)
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
        plannerController.delegate = self
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
        return 130
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
        deleteAction.backgroundColor = .disciplineBlue
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// PlannerController에서 설정한 할 일 목록들을 받아서 처리하는 Delegate ⭐️
extension TodoController: SendPlanDelegate {
    func sendPlan(_ plan: String) {
        self.plan = plan
    }
    
    func sendDetailPlan(_ plan: String) {
        self.detailPlan = plan
    }
    
    func sendTime(start: String, end: String) {
        self.startTime = start
        self.endTime = end
    }
    
    func sendHowManyTimesToRepeat(_ repetition: String) {
        self.repetition = repetition
    }
    
    func sendPriorityColor(_ priorityColor: UIColor) {
        self.priorityColor = priorityColor
    }
    
    func sendAlert(with state: Bool) {
        self.alertIsOn = state
    }
}

