//
//  EditNoteFeature.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import CoreLocation

@Reducer
struct EditNoteFeature {
    @ObservableState
    struct State: Equatable {
        let originalNote: Note
        var title: String
        var body: String
        var isSaving = false
        var errorMessage: String?
        
        init(note: Note) {
            self.originalNote = note
            self.title = note.title
            self.body = note.body
        }
        
        var hasChanges: Bool {
            title != originalNote.title || body != originalNote.body
        }
    }
    
    enum Action {
        case titleChanged(String)
        case bodyChanged(String)
        case saveTapped
        case cancelTapped
        case saveResponse(Result<Note, Error>)
        case delegate(Delegate)
        
        enum Delegate {
            case noteUpdated(Note)
        }
    }
    
    @Dependency(\.notesClient) var notesClient
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
                
            case .saveTapped:
                state.isSaving = true
                state.errorMessage = nil
                
                return .run { [state] send in
                    await send(.saveResponse(
                        Result {
                            var updatedNote = state.originalNote
                            updatedNote.title = state.title
                            updatedNote.body = state.body
                            
                            return try await notesClient.saveNote(updatedNote)
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
                    await send(.delegate(.noteUpdated(note)))
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
