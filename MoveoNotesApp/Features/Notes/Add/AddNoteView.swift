//
//  AddNoteView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct AddNoteView: View {
    @Bindable var store: StoreOf<AddNoteFeature>
    
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
                
                Section {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        
                        if store.isLocationLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Getting location...")
                                .foregroundColor(.secondary)
                        } else if let location = store.currentLocation {
                            VStack(alignment: .leading) {
                                Text("Location captured")
                                    .foregroundColor(.secondary)
                                Text("Lat: \(location.coordinate.latitude, specifier: "%.4f"), Lng: \(location.coordinate.longitude, specifier: "%.4f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Button("Add Location") {
                                store.send(.getCurrentLocation)
                            }
                            .foregroundColor(.blue)
                        }
                        
                        Spacer()
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
            .navigationTitle("New Note")
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
                    .disabled(store.title.isEmpty || store.isSaving)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                store.send(.getCurrentLocation)
            }
        }
        .interactiveDismissDisabled(store.isSaving)
        .overlay {
            if store.isSaving {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView("Saving...")
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                    }
            }
        }
    }
}
