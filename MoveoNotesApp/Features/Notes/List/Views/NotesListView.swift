//
//  NotesListView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import SwiftUI

struct NotesListView: View {
    @Bindable var store: StoreOf<NotesListFeature>
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $store.searchText.sending(\.searchTextChanged))
                
                if store.isLoading {
                    ProgressView("Loading notes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if store.filteredNotes.isEmpty {
                    EmptyNotesView()
                } else {
                    List {
                        ForEach(store.filteredNotes) { note in
                            NoteRowDetail(note: note) {
                                store.send(.editNoteTapped(note))
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                store.send(.deleteNote(store.filteredNotes[index].id))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.backButtonTapped)
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            store.send(.mapButtonTapped)
                        } label: {
                            Image(systemName: "map")
                        }
                        
                        Button {
                            store.send(.addNoteTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(item: $store.scope(state: \.addNote, action: \.addNote)) { store in
                AddNoteView(store: store)
            }
            .sheet(item: $store.scope(state: \.editNote, action: \.editNote)) { store in
                EditNoteView(store: store)
            }
            .sheet(item: $store.scope(state: \.notesMap, action: \.notesMap)) { store in
                NotesMapView(store: store)
            }
        }
    }
}


#Preview {
    NotesListView(store: Store(initialState: NotesListFeature.State(user: User(id: "", email: ""), notes:[.mock]), reducer: {
        NotesListFeature()
    }))
}
