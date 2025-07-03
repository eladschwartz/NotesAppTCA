//
//  NoteDetailSheetView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI

struct NoteDetailSheet: View {
    let note: Note
    let onDismiss: () -> Void
    let onEdit: (Note) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if !note.body.isEmpty {
                        Text(note.body)
                            .font(.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Created", systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(note.createdAt, style: .date)
                            .font(.body)
                        
                        Label("Location", systemImage: "location")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Lat: \(note.location?.latitude ?? 0, specifier: "%.4f"), Lng: \(note.location?.longitude ?? 0, specifier: "%.4f")")
                            .font(.body)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Note Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit") {
                        onEdit(note)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                }
            }
        }
    }
}
