//
//  AnimalFactsView.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import SwiftUI
import ComposableArchitecture

struct AnimalFactsView: View {
    
    let store: StoreOf<FactsFeature>
    
    var body: some View {
        ZStack {
            Color.pink
                .cornerRadius(20)
            
            self.cardView
                .padding()
        }
        .frame(height: 250)
        .padding()
    }
    
    private var cardView: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                AsyncImage(url: viewStore.animal.content?[viewStore.currentFact].image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 120)
                }


                Text(viewStore.animal.description)

                VStack {
                    Text(viewStore.animal.content?[viewStore.currentFact].fact ?? "")
                        .multilineTextAlignment(.center)

                    Spacer()

                    HStack {
                        Button {
                            viewStore.send(.previousButtonTapped)
                        } label: {
                            Text("<")
                        }
                        .disabled(viewStore.currentFact < 1)

                        Button {
                            viewStore.send(.nextButtonTapped)
                        } label: {
                            Text(">")
                        }
                        .disabled(viewStore.currentFact + 1 >= viewStore.animal.content?.count ?? 0)
                    }
                }
                .frame(height: 150)
                .padding(.horizontal)
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded({ gesture in
                            if gesture.translation.width > 0 {
                                viewStore.send(.previousButtonTapped)
                            } else {
                                viewStore.send(.nextButtonTapped)
                            }
                        })
                )
                .animation(.easeInOut, value: viewStore.currentFact)
            }
        }
    }
}

struct AnimalFactsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalFactsView(
            store: Store(initialState: FactsFeature.State(animal: .mock)) {
                FactsFeature()
            }
        )
    }
}
