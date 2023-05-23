//
//  AnimalFactsFeature.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import ComposableArchitecture

struct AnimalFactsFeature: ReducerProtocol {
    
    struct State: Equatable {
        var animal: Animal
        var currentFact = 0
    }
    
    enum Action {
        case previousButtonTapped
        case nextButtonTapped
        case indexChanged(to: Int)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .previousButtonTapped:
            if state.currentFact > 0 {
                state.currentFact -= 1
            }
            return .none
            
        case .nextButtonTapped:
            if state.currentFact + 1 < state.animal.content?.count ?? 0 {
                state.currentFact += 1
            }
            return .none
            
        case let .indexChanged(to: newIndex):
            state.currentFact = newIndex
            return .none
        }
    }
}
