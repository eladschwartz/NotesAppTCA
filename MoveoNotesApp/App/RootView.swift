//
//  RootView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<RootReducer>
    
    var body: some View {
        Group {
            switch store.state {
            case .authentication:
                if let store = store.scope(state: \.authentication, action: \.authentication) {
                    AuthenticationView(store: store)
                }
            case .welcome:
                if let store = store.scope(state: \.welcome, action: \.welcome) {
                    WelcomeView(store: store)
                }
            case .notesList:
                if let store = store.scope(state: \.notesList, action: \.notesList) {
                    NotesListView(store: store)
                }
            }
        }
        .onAppear {
                store.send(.onAppear)
            }
    }
}
