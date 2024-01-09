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
        case createPlanButtonTapped
    }
    
    enum Mutation {
        case sendPlanToToDoController(Bool)
    }

    struct State {
        var receivedPlan: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .createPlanButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.sendPlanToToDoController(true)),
                Observable.just(Mutation.sendPlanToToDoController(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .sendPlanToToDoController(let value):
            newState.receivedPlan = value
        }
        
        return newState
    }
}

