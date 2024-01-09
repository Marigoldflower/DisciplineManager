//
//  RepetitionViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/09.
//

import Foundation
import ReactorKit

final class RepetitionViewModel: Reactor {
    
    enum Action {
        case selectSegment(String)
    }
    
    enum Mutation {
        case setSegment(String)
    }
    
    struct State {
        var selectedSegment: String = ""
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectSegment(segment):
            return Observable.just(.setSegment(segment))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSegment(segment):
            newState.selectedSegment = segment
        }
        return newState
    }
    
}

