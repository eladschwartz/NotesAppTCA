//
//  WelcomeFeature.Swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//


import ComposableArchitecture

@Reducer
struct WelcomeFeature {
    @Dependency(\.authenticationClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        var user: User
        
        init(user: User) {
            self.user = user
        }
    }
    
    enum Action {
        case continueToNotes
        case logout
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueToNotes:
                return .none
                
            case .logout:
                return .run { _ in
                    try await authClient.signOut()
                }
            }
        }
    }
}
