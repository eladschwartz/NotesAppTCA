//
//  EditNoteView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct EditNoteView: View {
    @Bindable var store: StoreOf<EditNoteFeature>
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $store.title.sending(\.titleChanged))
                        .font(.headline)
                }
                
                Section(header: Text("Content")) {
                    TextField("Enter Content", text: $store.body.sending(\.bodyChanged), axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section(header: Text("Note Info")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text("Created")
                            Spacer()
                            Text(store.originalNote.createdAt, style: .date)
                                .foregroundColor(.secondary)
                        }
                        
                        
                        if let location = store.originalNote.location {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                Text("Location")
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Lat: \(location.latitude, specifier: "%.4f")")
                                    Text("Lng: \(location.longitude, specifier: "%.4f")")
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                if let errorMessage = store.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        store.send(.cancelTapped)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        store.send(.saveTapped)
                    }
                    .disabled(store.title.isEmpty || store.isSaving || !store.hasChanges)
                    .fontWeight(.semibold)
                }
            }
        }
        .interactiveDismissDisabled(store.isSaving)
        .overlay {
            if store.isSaving {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView("Updating...")
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                    }
            }
        }
    }
}
