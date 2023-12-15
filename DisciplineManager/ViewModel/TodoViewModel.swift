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
        case addTodoListButtonTapped
    }
    
    enum Mutation {
        case showFullCalendar(Bool)
        case showPlanner(Bool)
    }

    struct State {
        var isFullCalendarShown: Bool = false
        var isPlannerShown: Bool = false
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
            
        case .addTodoListButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.showPlanner(true)),
                Observable.just(Mutation.showPlanner(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showFullCalendar(let value):
            newState.isFullCalendarShown = value
            
        case .showPlanner(let value):
            newState.isPlannerShown = value
        }
        
        return newState
    }
}
