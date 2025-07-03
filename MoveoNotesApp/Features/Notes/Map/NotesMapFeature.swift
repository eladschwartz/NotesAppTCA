//
//  NotesMapFeature.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import MapKit

@Reducer
struct NotesMapFeature {
    @Dependency(\.notesClient) var notesClient
    
    @ObservableState
    struct State: Equatable {
        var user: User
        var notes: IdentifiedArrayOf<Note> = []
        var selectedNote: Note?
        var mapRegion = MapRegion(center: CLLocationCoordinate2D(latitude: 31.0461, longitude: 34.8516), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        var isLoading = false
        @Presents var editNote: EditNoteFeature.State?
        
        init(user: User, notes: IdentifiedArrayOf<Note> = []) {
            self.user = user
            self.notes = notes
        }
    }
    
    enum Action {
        case noteSelected(Note?)
        case mapRegionChanged(MapRegion)
        case editNoteTapped(Note)
        case editNote(PresentationAction<EditNoteFeature.Action>)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .noteSelected(let note):
                state.selectedNote = note
                return .none
                
            case .mapRegionChanged(let region):
                state.mapRegion = region
                return .none
                
            case .editNoteTapped(let note):
                state.editNote = EditNoteFeature.State(note: note)
                return .none
                
            case .editNote(.presented(.delegate(.noteUpdated(let note)))):
                state.editNote = nil
                if let index = state.notes.firstIndex(where: { $0.id == note.id }) {
                    state.notes[index] = note
                }
                return .none
                
            case .editNote:
                return .none
            }
        }
        .ifLet(\.$editNote, action: \.editNote) {
            EditNoteFeature()
        }
    }
}
