//
//  PromovaTestApp.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct PromovaTestApp: App {
    
    let store = Store(initialState: AnimalsListFeature.State()) {
        AnimalsListFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AnimalsListView(store: self.store)
        }
    }
}
