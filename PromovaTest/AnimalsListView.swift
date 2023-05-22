//
//  AnimalsListView.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import SwiftUI
import ComposableArchitecture

struct AnimalsListView: View {
    
    @State private var shouldPresentAnimal = false
    
    let store: StoreOf<ListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    List(viewStore.animals, id: \.self) { animal in
                        self.animalCell(animal)
                            .onTapGesture {
                                viewStore.send(.animalTapped(animal))
                            }
                    }
                    .navigationTitle("Know Your Animal")
                }
                
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
                    AnimalFactsView(store: Store(initialState: FactsFeature.State(animal: animal)) {
                        FactsFeature()
                    })
                }
            }
            .onChange(of: viewStore.shouldShowAnimal) { newValue in
                self.shouldPresentAnimal = newValue
            }
        }
    }
    
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
        HStack {
            AsyncImage(url: animal.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask {
                        RoundedRectangle(cornerRadius: 20)
                    }
            } placeholder: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: 80, idealHeight: 60)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(animal.title)
                    .multilineTextAlignment(.trailing)
                
                Text(animal.description)
                    .multilineTextAlignment(.trailing)
            }
            
        }
        .padding(.vertical)
    }
}

struct AnimalsListView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalsListView(
            store: Store(initialState: ListFeature.State()) {
                ListFeature()
            }
        )
    }
}
