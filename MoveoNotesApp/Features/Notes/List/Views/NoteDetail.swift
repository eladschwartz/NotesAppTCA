//
//  NoteDetail.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI

struct NoteRowDetail: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Text(note.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !note.body.isEmpty {
                Text(note.body)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    NoteRowDetail(note: .mock){
        
    }
        
    
}
