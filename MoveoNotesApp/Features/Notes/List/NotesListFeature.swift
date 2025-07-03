//
//  NotesListFeature.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NotesListFeature {
    
    @Dependency(\.notesClient) var notesClient
    
    @ObservableState
    struct State: Equatable {
        var user: User
        var notes: IdentifiedArrayOf<Note> = []
        var isLoading = false
        var searchText = ""
        @Presents var addNote: AddNoteFeature.State?
        @Presents var editNote: EditNoteFeature.State?
        @Presents var notesMap: NotesMapFeature.State?
        
        var filteredNotes: IdentifiedArrayOf<Note> {
            searchText.isEmpty ? notes : notes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.body.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        init(user: User, notes: IdentifiedArrayOf<Note> = []) {
            self.user = user
            self.notes = notes
        }
    }
    
    enum Action {
        case onAppear
        case searchTextChanged(String)
        case notesLoaded(IdentifiedArrayOf<Note>)
        case deleteNote(Note.ID)
        case editNoteTapped(Note)
        case addNoteTapped
        case mapButtonTapped
        case backButtonTapped
        case addNote(PresentationAction<AddNoteFeature.Action>)
        case editNote(PresentationAction<EditNoteFeature.Action>)
        case notesMap(PresentationAction<NotesMapFeature.Action>)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let notes = try await notesClient.fetchNotes()
                    await send(.notesLoaded(notes))
                }
                
            case .searchTextChanged(let text):
                state.searchText = text
                return .none
                
            case .notesLoaded(let notes):
                state.isLoading = false
                state.notes = notes
                return .none
                
            case .deleteNote(let id):
                return .run { send in
                    try await notesClient.deleteNote(id)
                    let notes = try await notesClient.fetchNotes()
                    await send(.notesLoaded(notes))
                }
                
            case .editNoteTapped(let note):
                state.editNote = EditNoteFeature.State(note: note)
                return .none
                
            case .addNoteTapped:
                state.addNote = AddNoteFeature.State()
                return .none
                
            case .mapButtonTapped:
                state.notesMap = NotesMapFeature.State(user: state.user, notes: state.notes)
                return .none
                
            case .backButtonTapped:
                return .none
                
            case .addNote(.presented(.delegate(.noteSaved(let note)))):
                state.addNote = nil
                state.notes.insert(note, at: 0)
                return .none
                
            case .editNote(.presented(.delegate(.noteUpdated(let note)))):
                state.editNote = nil
                if let index = state.notes.firstIndex(where: { $0.id == note.id }) {
                    state.notes[index] = note
                }
                return .none
                
                
            case .notesMap(.presented(.editNote(.presented(.delegate(.noteUpdated(let note)))))):
                if let index = state.notes.firstIndex(where: { $0.id == note.id }) {
                    state.notes[index] = note
                }
                return .none
                
            case .addNote, .editNote, .notesMap:
                return .none
            }
        }
        .ifLet(\.$addNote, action: \.addNote) {
            AddNoteFeature()
        }
        .ifLet(\.$editNote, action: \.editNote) {
            EditNoteFeature()
        }
        .ifLet(\.$notesMap, action: \.notesMap) {
            NotesMapFeature()
        }
    }
}
