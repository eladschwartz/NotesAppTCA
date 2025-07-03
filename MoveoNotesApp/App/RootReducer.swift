//
//  RootReducer.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture

@Reducer
struct RootReducer {
    
    @Dependency(\.authenticationClient) var authClient
    
    @ObservableState
    enum State: Equatable {
        case authentication(AuthenticationFeature.State)
        case welcome(WelcomeFeature.State)
        case notesList(NotesListFeature.State)
    }
    
    enum Action {
        case onAppear
        case authentication(AuthenticationFeature.Action)
        case welcome(WelcomeFeature.Action)
        case notesList(NotesListFeature.Action)
        case checkAuthenticationResponse(User?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let currentUser = authClient.getCurrentUser()
                    await send(.checkAuthenticationResponse(currentUser))
                }
                
            case .checkAuthenticationResponse(let user):
                if let user = user {
                    state = .welcome(WelcomeFeature.State(user: user))
                } else {
                    state = .authentication(AuthenticationFeature.State())
                }
                return .none
                
            case .authentication(.authResponse(.success(let user))):
                state = .welcome(WelcomeFeature.State(user: user))
                return .none
                
            case .welcome(.logout):
                state = .authentication(AuthenticationFeature.State())
                return .none
                
            case .welcome(.continueToNotes):
                if case .welcome(let welcomeState) = state {
                    state = .notesList(NotesListFeature.State(user: welcomeState.user))
                }
                return .none
                
            case .notesList(.backButtonTapped):
                if case .notesList(let notesState) = state {
                    state = .welcome(WelcomeFeature.State(user: notesState.user))
                }
                return .none
                
            default:
                return .none
            }
        }
        .ifCaseLet(\.authentication, action: \.authentication) {
            AuthenticationFeature()
        }
        .ifCaseLet(\.welcome, action: \.welcome) {
            WelcomeFeature()
        }
        .ifCaseLet(\.notesList, action: \.notesList) {
            NotesListFeature()
        }
    }
}
