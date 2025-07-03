//
//  WelcomeView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: StoreOf<WelcomeFeature>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 80) {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "map.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to Moveo Notes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button {
                        store.send(.continueToNotes)
                    } label: {
                        Text("Continue to Notes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        store.send(.logout)
                    } label: {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    WelcomeView(store: Store(initialState: WelcomeFeature.State(user: User(id:"454", email: "ttrt")), reducer: {
        WelcomeFeature()
    }))
}
