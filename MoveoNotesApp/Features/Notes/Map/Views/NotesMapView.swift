//
//  NotesMapView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct NotesMapView: View {
    @Bindable var store: StoreOf<NotesMapFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: .init(
                    get: { store.mapRegion.mkCoordinateRegion },
                    set: { store.send(.mapRegionChanged(MapRegion(region: $0))) }
                ),
                    annotationItems: store.notes) { note in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: note.location?.latitude ?? 0,
                        longitude: note.location?.longitude ?? 0
                    )) {
                        NoteMapPin(
                            note: note,
                            isSelected: store.selectedNote?.id == note.id
                        ) {
                            store.send(.noteSelected(note))
                        }
                    }
                }
                .ignoresSafeArea()
                
                if store.isLoading {
                    ProgressView("Loading notes...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: Binding(
                get: { store.selectedNote != nil },
                set: { if !$0 { store.send(.noteSelected(nil)) } }
            )) {
                if let selectedNote = store.selectedNote {
                    NoteDetailSheet(note: selectedNote) {
                        store.send(.noteSelected(nil))
                    } onEdit: { note in
                        store.send(.editNoteTapped(note))
                        store.send(.noteSelected(nil))
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { store.editNote != nil },
                set: { if !$0 {
                } }
            )) {
                if let editStore = store.scope(state: \.editNote, action: \.editNote) {
                    NavigationStack {
                        EditNoteView(store: editStore.scope(state: \.self, action: \.presented))
                    }
                }
            }
        }
    }
}


#Preview {
    NotesMapView(store: Store(initialState: NotesMapFeature.State(user: User(id: "545", email: "trtr")), reducer: {
        NotesMapFeature()
    }))
}
