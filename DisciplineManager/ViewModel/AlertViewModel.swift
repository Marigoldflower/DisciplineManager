//
//  AlertViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/09.
//

import Foundation
import ReactorKit

final class AlertViewModel: Reactor {
    
    enum Action {
        case alertIsChanged(Bool)
    }
    
    enum Mutation {
        case settingAlert(Bool)
    }

    struct State {
        var alertStateIsChanged: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .alertIsChanged(let state):
            return Observable.just(Mutation.settingAlert(state))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .settingAlert(let state):
            newState.alertStateIsChanged = state
        }
        
        return newState
    }
}

