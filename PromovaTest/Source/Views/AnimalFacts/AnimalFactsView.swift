//
//  AnimalFactsView.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import SwiftUI
import ComposableArchitecture

struct AnimalFactsView: View {
    
    // MARK: - Variables
    
    let store: StoreOf<AnimalFactsFeature>
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var currentFactIndex = 0
    
    // MARK: - Body
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                
                VStack {
                    self.closeButton
                    
                    if viewStore.animal.content == nil {
                        Text("There are no facts about this animal.")
                    } else {
                        VStack {
                            self.tabView
                            self.buttonsView
                        }
                    }
                    
                    Spacer()
                }
                
            }
            .onChange(of: self.currentFactIndex) { newValue in
                viewStore.send(.indexChanged(to: newValue))
            }
            .onChange(of: viewStore.currentFact) { newValue in
                self.currentFactIndex = newValue
            }
        }
    }
    
    // MARK: - Views
    
    private var closeButton: some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private var tabView: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: self.$currentFactIndex) {
                if let content = viewStore.animal.content {
                    ForEach(content.indices, id: \.self) { index in
                        self.tabViewCard(fact: content[index])
                            .tag(index)
                    }
                    .padding(10)
                }
            }
            .animation(.linear, value: self.currentFactIndex)
            .frame(height: 350)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private func tabViewCard(fact: Animal.Fact) -> some View {
        ZStack {
            Color.white
            
            VStack {
                AsyncImage(url: fact.image) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .mask {
                            RoundedRectangle(cornerRadius: 20)
                        }
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 120)
                }
                
                Text(fact.fact)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var buttonsView: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.previousButtonTapped)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "arrow.left")
                    }
                }
                .disabled(viewStore.currentFact < 1)
                
                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "arrow.right")
                    }
                }
                .disabled(viewStore.currentFact + 1 >= viewStore.animal.content?.count ?? 0)
            }
            .padding()
        }
    }
}

struct AnimalFactsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalFactsView(
            store: Store(initialState: AnimalFactsFeature.State(animal: .mock)) {
                AnimalFactsFeature()
            }
        )
    }
}
