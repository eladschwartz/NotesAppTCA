//
//  AddNoteFeatureTests.swift
//  MoveoNotesApp
//
//  Created by elad on 03/07/2025.
//


import ComposableArchitecture
import XCTest

@testable import MoveoNotesApp

@MainActor
final class AddNoteFeatureTests: XCTestCase {
    func testSaveNoteWithoutLocation() async {
        let expectedNote = Note(
            id: "noteid1234",
            title: "Test Note",
            body: "Test content",
            createdAt: Date(),
            location: nil,
            userId: "userid789"
        )
        
        let store = TestStore(
            initialState: AddNoteFeature.State(
                title: "Test Note",
                body: "Test content",
                currentLocation: nil
            )
        ) {
            AddNoteFeature()
        } withDependencies: {
            $0.notesClient.saveNote = { note in
                XCTAssertEqual(note.title, "Test Note")
                XCTAssertEqual(note.body, "Test content")
                XCTAssertNil(note.location)
                XCTAssertEqual(note.userId, "userid789")
                
                return expectedNote
            }
            $0.authenticationClient.getCurrentUser = {
                User(id: "userid789", email: "test@gmail.com")
            }
            $0.dismiss = DismissEffect {}
        }
        
        await store.send(.saveTapped) {
            $0.isSaving = true
            $0.errorMessage = nil
        }
        
        store.exhaustivity = .off
    }
    
//    func testNoteDeletion() async {
//        let note  = Note.mock
//        let store = TestStore(
//            initialState: NotesListFeature.State(user: User(id:"1234", email:"e@gmail.com"), notes: [.mock])
//        ) {
//            NotesListFeature()
//        }
//        
//        
//        await store.send(.deleteNote([0])) {
//            $0.syncUps = []
//        }
//    }
}


