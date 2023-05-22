//
//  FactsFeature.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import ComposableArchitecture

struct FactsFeature: ReducerProtocol {
    
    struct State: Equatable {
        var animal: Animal
        var currentFact = 0
    }
    
    enum Action {
        case previousButtonTapped
        case nextButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .previousButtonTapped:
            state.currentFact -= 1
            return .none
            
        case .nextButtonTapped:
            state.currentFact += 1
            return .none
        }
    }
}
