//
//  AddNoteFeature.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import CoreLocation
import FirebaseFirestore

@Reducer
struct AddNoteFeature {
    @ObservableState
    struct State: Equatable, Sendable {
        var title = ""
        var body = ""
        var isSaving = false
        var errorMessage: String?
        var isLocationLoading = false
        var currentLocation: EquatableCoordinate?
    }
    
    enum Action {
        case titleChanged(String)
        case bodyChanged(String)
        case saveTapped
        case cancelTapped
        case getCurrentLocation
        case locationResponse(Result<EquatableCoordinate, Error>)
        case saveResponse(Result<Note, Error>)
        case delegate(Delegate)
        
        enum Delegate {
            case noteSaved(Note)
        }
    }
    
    @Dependency(\.authenticationClient) var authClient
    @Dependency(\.notesClient) var notesClient
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .titleChanged(let title):
                state.title = title
                return .none
                
            case .bodyChanged(let body):
                state.body = body
                return .none
                
            case .getCurrentLocation:
                state.isLocationLoading = true
                return .run { send in
                    await send(.locationResponse(
                        Result {
                            let hasPermission = await locationClient.requestPermission()
                            guard hasPermission else {
                                throw LocationError.permissionDenied
                            }
                            return try await locationClient.getCurrentLocation()
                        }
                    ))
                }
                
            case .locationResponse(.success(let location)):
                state.isLocationLoading = false
                state.currentLocation = location
                return .none
                
            case .locationResponse(.failure(let error)):
                state.isLocationLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .saveTapped:
                state.isSaving = true
                state.errorMessage = nil
                
                return .run { [state] send in
                    await send(.saveResponse(
                        Result {
                            var note = Note.createEmpty()
                            note.title = state.title
                            note.body = state.body
                            note.userId = authClient.getCurrentUser()?.id ?? ""
                            
                            if let location = state.currentLocation {
                                note.location = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            }
                            
                            return try await notesClient.saveNote(note)
                        }
                    ))
                }
                
            case .cancelTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .saveResponse(.success(let note)):
                state.isSaving = false
                return .run { send in
                    await send(.delegate(.noteSaved(note)))
                    await dismiss()
                }
                
            case .saveResponse(.failure(let error)):
                state.isSaving = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
