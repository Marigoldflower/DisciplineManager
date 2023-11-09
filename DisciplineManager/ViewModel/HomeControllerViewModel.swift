//
//  HomeControllerViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/08.
//

import Foundation
import ReactorKit

final class HomeControllerViewModel: Reactor {
    enum Action {
        case setDateButton_TextVersionTapped
        case setDateButton_ImageVersionTapped
    }
    
    enum Mutation {
        case showFullCalendar(Bool)
    }

    struct State {
        var isFullCalendarShown: Bool = false
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showFullCalendar(let value):
            newState.isFullCalendarShown = value
        }
        
        return newState
    }
}
