//
//  PlannerViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/27.
//

import Foundation
import ReactorKit

final class PlannerViewModel: Reactor {
    
    enum Action {
        case timeSelectButtonTapped
    }
    
    enum Mutation {
        case presentDatePicker(Bool)
    }

    struct State {
        var datePickerIsPresented: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .timeSelectButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.presentDatePicker(true)),
                Observable.just(Mutation.presentDatePicker(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .presentDatePicker(let value):
            newState.datePickerIsPresented = value
        }
        
        return newState
    }
}

