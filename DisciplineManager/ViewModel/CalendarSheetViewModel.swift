//
//  CalendarSheetViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/21.
//

import Foundation
import ReactorKit

final class CalendarSheetViewModel: Reactor {
    
    enum Action {
        case exitButtonTapped
        case selectButtonTapped
    }
    
    enum Mutation {
        case dismissFullCalendar(Bool)
        case changeDate(Bool)
    }

    struct State {
        var fullCalendarIsDismissed: Bool = false
        var dateIsChanged: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .exitButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.dismissFullCalendar(true)),
                Observable.just(Mutation.dismissFullCalendar(false))
            ])
        case .selectButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.changeDate(true)),
                Observable.just(Mutation.changeDate(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .dismissFullCalendar(let value):
            newState.fullCalendarIsDismissed = value
        case .changeDate(let value):
            newState.dateIsChanged = value
        }
        
        return newState
    }
}
