//
//  NotesClient.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//


import ComposableArchitecture
import FirebaseFirestore
import FirebaseAuth


struct NotesClient {
    var fetchNotes: () async throws -> IdentifiedArrayOf<Note>
    var saveNote: (Note) async throws -> Note
    var deleteNote: (Note.ID) async throws -> Void
}

let FIRESTORE_NOTES_COLLECTION = Firestore.firestore().collection("notes")

extension NotesClient: DependencyKey {
    static let liveValue = NotesClient(
        fetchNotes: {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw NotesError.notAuthenticated
            }
            
            let snapshot = try await
                FIRESTORE_NOTES_COLLECTION
                .whereField("userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            let notes = try snapshot.documents.compactMap { document in
                try document.data(as: Note.self)
            }
            
            return IdentifiedArrayOf(uniqueElements: notes)
        },
        saveNote: { note in
            guard let userId = Auth.auth().currentUser?.uid else {
                throw NotesError.notAuthenticated
            }
            
            var noteToSave = note
            noteToSave.userId = userId
            
            if let existingId = note.id {
                // Update note
                let data = try Firestore.Encoder().encode(noteToSave)
                let ref = FIRESTORE_NOTES_COLLECTION.document(existingId)
                try await ref.setData(data)
                return noteToSave
            } else {
                // Create new note
                let data = try Firestore.Encoder().encode(noteToSave)
                let ref = try await FIRESTORE_NOTES_COLLECTION.addDocument(data: data)
                
                noteToSave.id = ref.documentID
                return noteToSave
            }
        },
        deleteNote: { id in
            let ref = FIRESTORE_NOTES_COLLECTION.document(id ?? "")
            try await ref.delete()
        }
    )
}

enum NotesError: LocalizedError {
    case notAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be logged in to access notes."
        }
    }
}

extension DependencyValues {
    var notesClient: NotesClient {
        get { self[NotesClient.self] }
        set { self[NotesClient.self] = newValue }
    }
}
