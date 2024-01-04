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
        case startTimePickerSelectButtonTapped
        case endTimePickerSelectButtonTapped
    }
    
    enum Mutation {
        case settingStartTime(Bool)
        case settingEndTime(Bool)
    }

    struct State {
        var startTime: Bool = false
        var endTime: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startTimePickerSelectButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.settingStartTime(true)),
                Observable.just(Mutation.settingStartTime(false))
            ])
            
        case .endTimePickerSelectButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.settingEndTime(true)),
                Observable.just(Mutation.settingEndTime(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .settingStartTime(let value):
            newState.startTime = value
            
        case .settingEndTime(let value):
            newState.endTime = value
        }
        
        return newState
    }
}

