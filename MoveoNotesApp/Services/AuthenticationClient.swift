//
//  AuthenticationClient.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import FirebaseAuth

struct User: Equatable {
    let id: String
    let email: String
}

struct AuthenticationClient {
    var signIn: (String, String) async throws -> User
    var signUp: (String, String) async throws -> User
    var signOut: () async throws -> Void
    var getCurrentUser: () -> User?
}

extension AuthenticationClient: DependencyKey {
    static let liveValue = AuthenticationClient(
        signIn: { email, password in
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return User(id: result.user.uid, email: result.user.email ?? "")
        },
        signUp: { email, password in
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return User(id: result.user.uid, email: result.user.email ?? "")
        },
        signOut: {
            try Auth.auth().signOut()
        },
        getCurrentUser: {
            guard let user = Auth.auth().currentUser else { return nil }
            return User(id: user.uid, email: user.email ?? "")
        }
    )
}

extension DependencyValues {
    var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}
