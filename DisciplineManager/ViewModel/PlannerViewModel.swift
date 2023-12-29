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
        case startDatePickerButtonTapped
        case endDatePickerButtonTapped
    }
    
    enum Mutation {
        case presentStartDatePicker(Bool)
        case presentEndDatePicker(Bool)
    }

    struct State {
        var startDatePickerIsPresented: Bool = false
        var endDatePickerIsPresented: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startDatePickerButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.presentStartDatePicker(true)),
                Observable.just(Mutation.presentStartDatePicker(false))
            ])
            
        case .endDatePickerButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.presentEndDatePicker(true)),
                Observable.just(Mutation.presentEndDatePicker(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .presentStartDatePicker(let value):
            newState.startDatePickerIsPresented = value
            
        case .presentEndDatePicker(let value):
            newState.endDatePickerIsPresented = value
        }
        
        return newState
    }
}

