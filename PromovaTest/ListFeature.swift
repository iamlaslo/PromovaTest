//
//  ListFeature.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import Foundation
import ComposableArchitecture

struct ListFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = true
        var animals: [Animal] = []
        var shouldShowAnimal = false
        var animalToShow: Animal?
    }
    
    enum Action {
        case appRunning
        case animalsResponse([Animal])
        case animalTapped(Animal)
        case animalClosed
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .appRunning:
            return .run { send in
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!)
                let response = try JSONDecoder().decode([Animal].self, from: data)
                await send(.animalsResponse(response))
            }
            
        case let .animalsResponse(response):
            state.animals = response.sorted(by: { $0.order < $1.order })
            state.isLoading = false
            return .none
            
        case let .animalTapped(animal):
            switch animal.status {
            case .free:
                state.animalToShow = animal
                state.shouldShowAnimal = true
            case .paid:
                state.animalToShow = animal
                state.shouldShowAnimal = true
            case .comingSoon:
                break
            }
            return .none
            
        case .animalClosed:
            state.shouldShowAnimal = false
            return .none
        }
    }
}
