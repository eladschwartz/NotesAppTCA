//
//  NoteMapPinView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI

struct NoteMapPin: View {
    let note: Note
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.red)
                    .frame(width: isSelected ? 24 : 20, height: isSelected ? 24 : 20)
                
                Image(systemName: "note.text")
                    .foregroundColor(.white)
                    .font(.system(size: isSelected ? 12 : 10, weight: .bold))
            }
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
