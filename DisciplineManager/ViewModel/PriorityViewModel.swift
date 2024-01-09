//
//  PriorityViewModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/09.
//

import Foundation
import ReactorKit

final class PriorityViewModel: Reactor {
    
    enum Action {
        case highButtonTapped
        case mediumButtonTapped
        case lowButtonTapped
    }
    
    enum Mutation {
        case settingHighColor(Bool)
        case settingMediumColor(Bool)
        case settingLowColor(Bool)
    }

    struct State {
        var highButtonIsSelected: Bool = false
        var mediumButtonIsSelected: Bool = false
        var lowButtonIsSelected: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .highButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.settingHighColor(true)),
                Observable.just(Mutation.settingHighColor(false))
            ])
            
        case .mediumButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.settingMediumColor(true)),
                Observable.just(Mutation.settingMediumColor(false))
            ])
            
        case .lowButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.settingLowColor(true)),
                Observable.just(Mutation.settingLowColor(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .settingHighColor(let value):
            newState.highButtonIsSelected = value
            
        case .settingMediumColor(let value):
            newState.mediumButtonIsSelected = value
            
        case .settingLowColor(let value):
            newState.lowButtonIsSelected = value
        }
        
        return newState
    }
}

