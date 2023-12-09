//
//  HomeControllerViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/08.
//

import UIKit
import ReactorKit
import RxRelay

final class TodoViewModel: Reactor {
    
    var todo = BehaviorRelay<[TodoModel]>(value: [])
    var todoObserver: Observable<[TodoModel]> {
        return todo.asObservable()
    }
    
    func getTodoList() {
        self.todo.accept(todoList)
    }
    
    var todoList: [TodoModel] = [
        TodoModel(time: "오전 7:20", whatToDo: "기상"),
        TodoModel(time: "오후 11:00", whatToDo: "굿 나잇!")
    ]
    
    enum Action {
        case setDateButton_TextVersionTapped
        case setDateButton_ImageVersionTapped
        case taskIsFinishedButtonTapped
        case trashButtonTapped
    }
    
    enum Mutation {
        case showFullCalendar(Bool)
        case checkingTaskCheckBox(Bool)
        case eraseTodoList(Bool)
    }

    struct State {
        var isFullCalendarShown: Bool = false
        var taskCheckBoxIsChecked: Bool = false
        var eraseTodoList: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setDateButton_TextVersionTapped:
            return Observable.concat([
                Observable.just(Mutation.showFullCalendar(true)),
                Observable.just(Mutation.showFullCalendar(false))
            ])
            
        case .setDateButton_ImageVersionTapped:
            return Observable.concat([
                Observable.just(Mutation.showFullCalendar(true)),
                Observable.just(Mutation.showFullCalendar(false))
            ])
            
        case .taskIsFinishedButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.checkingTaskCheckBox(true)),
                Observable.just(Mutation.checkingTaskCheckBox(false))
            ])
            
        case .trashButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.eraseTodoList(true)),
                Observable.just(Mutation.eraseTodoList(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showFullCalendar(let value):
            newState.isFullCalendarShown = value
            
        case .checkingTaskCheckBox(let value):
            newState.taskCheckBoxIsChecked = value
            
        case .eraseTodoList(let value):
            newState.eraseTodoList = value
        }
        
        return newState
    }
}
