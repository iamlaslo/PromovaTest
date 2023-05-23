//
//  AnimalsListFeature.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import Foundation
import ComposableArchitecture

struct AnimalsListFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = true
        var animals: [Animal] = []
        var alertToShow: AnimalsListAlert?
        var shouldShowAnimal = false
        var animalToShow: Animal?
    }
    
    enum Action {
        case appRunning
        case animalsResponse([Animal])
        case animalTapped(Animal)
        case animalClosed
        case alertClosed
        case showAdTapped
        case adEnded
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .appRunning:
            return .run { send in
                guard let url = URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")
                else { return }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                do {
                    let response = try JSONDecoder().decode([Animal].self, from: data)
                    await send(.animalsResponse(response))
                } catch {
                    print("Network error: \(error.localizedDescription)")
                }
            }
            
        case let .animalsResponse(response):
            state.animals = response.sorted(by: { $0.order < $1.order })
            state.isLoading = false
            return .none
            
        case let .animalTapped(animal):
            state.animalToShow = animal
            switch animal.status {
            case .free:
                state.shouldShowAnimal = true
            case .paid:
                state.alertToShow = .showAd
            case .comingSoon:
                state.alertToShow = .comingSoon
            }
            return .none
            
        case .animalClosed:
            state.shouldShowAnimal = false
            state.animalToShow = .none
            return .none
            
        case .alertClosed:
            state.alertToShow = .none
            return .none
            
        case .showAdTapped:
            state.isLoading = true
            return .run { send in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    send(.adEnded)
                }
            }
            
        case .adEnded:
            state.isLoading = false
            state.shouldShowAnimal = true
            state.alertToShow = .none
            return .none
        }
    }
}
