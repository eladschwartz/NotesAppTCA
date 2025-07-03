//
//  AuthenticationFeature.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import Foundation

import ComposableArchitecture
import Foundation

@Reducer
struct AuthenticationFeature {
    @Dependency(\.authenticationClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        var email = ""
        var password = ""
        var isLoading = false
        var errorMessage: String?
        var isLoginMode = true
    }
    
    enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case toggleMode
        case loginTapped
        case signupTapped
        case authResponse(Result<User, Error>)
        case dismissError
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailChanged(let email):
                state.email = email
                return .none
                
            case .passwordChanged(let password):
                state.password = password
                return .none
                
            case .toggleMode:
                state.isLoginMode.toggle()
                state.errorMessage = nil
                return .none
                
            case .loginTapped:
                state.isLoading = true
                state.errorMessage = nil
                return .run { [email = state.email, password = state.password] send in
                    await send(.authResponse(
                        Result { try await authClient.signIn(email, password) }
                    ))
                }
                
            case .signupTapped:
                state.isLoading = true
                state.errorMessage = nil
                return .run { [email = state.email, password = state.password] send in
                    await send(.authResponse(
                        Result { try await authClient.signUp(email, password) }
                    ))
                }
                
            case .authResponse(.success):
                state.isLoading = false
                return .none
                
            case .authResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .dismissError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
