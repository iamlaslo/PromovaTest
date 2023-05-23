//
//  AnimalsListView.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import SwiftUI
import ComposableArchitecture

enum AnimalsListAlert {
    case showAd
    case comingSoon
}

struct AnimalsListView: View {
    
    // MARK: - Variables
    
    let store: StoreOf<AnimalsListFeature>
    
    @State private var shouldPresentAnimal = false
    @State private var shouldPresentAdAlert = false
    @State private var shouldPresentComingSoonAlert = false
    
    // MARK: - Body
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                List(viewStore.animals, id: \.self) { animal in
                    self.animalCell(animal)
                }
                .navigationTitle("Know Your Animal")
                
                if viewStore.isLoading {
                    self.spinnerView
                }
            }
            .onAppear() {
                viewStore.send(.appRunning)
            }
            .sheet(
                isPresented: self.$shouldPresentAnimal,
                onDismiss: {
                    viewStore.send(.animalClosed)
                }
            ) {
                if let animal = viewStore.animalToShow {
                    AnimalFactsView(store: Store(initialState: AnimalFactsFeature.State(animal: animal)) {
                        AnimalFactsFeature()
                    })
                }
            }
            .alert(
                "Watch Ad to continue",
                isPresented: self.$shouldPresentAdAlert,
                actions: {
                    Button {
                        viewStore.send(.alertClosed)
                    } label: {
                        Text("Cancel")
                    }
                    
                    Button {
                        viewStore.send(.showAdTapped)
                    } label: {
                        Text("Show Ad")
                    }
                }
            )
            .alert(
                "Coming Soon",
                isPresented: self.$shouldPresentComingSoonAlert,
                actions: {
                    Button {
                        return
                    } label: {
                        Text("OK")
                    }
                }
            )
            .onChange(of: viewStore.shouldShowAnimal) { newValue in
                self.shouldPresentAnimal = newValue
            }
            .onChange(of: viewStore.alertToShow) { newValue in
                switch newValue {
                case .showAd:
                    self.shouldPresentAdAlert = true
                case .comingSoon:
                    self.shouldPresentComingSoonAlert = true
                case .none:
                    return
                }
            }
        }
    }
    
    // MARK: - Views
    
    private var spinnerView: some View {
        Group {
            Color.gray
                .opacity(0.5)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            ProgressView()
        }
    }
    
    private func animalCell(_ animal: Animal) -> some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.white
                
                HStack {
                    AsyncImage(url: animal.image) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .mask {
                                RoundedRectangle(cornerRadius: 20)
                            }
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 80)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(animal.title)
                            .bold()
                            .multilineTextAlignment(.trailing)
                        
                        Text(animal.description)
                            .multilineTextAlignment(.trailing)
                        
                        Spacer()
                        
                        Text(animal.status.rawValue.uppercased())
                            .italic()
                    }
                    
                }
                .padding(.vertical)
            }
            .onTapGesture {
                viewStore.send(.animalTapped(animal))
            }
        }
    }
}

struct AnimalsListView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalsListView(
            store: Store(initialState: AnimalsListFeature.State()) {
                AnimalsListFeature()
            }
        )
    }
}
