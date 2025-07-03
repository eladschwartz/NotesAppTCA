//
//  Note.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Note: Equatable, Identifiable, Codable {
    @DocumentID var id  : String?
    var title           : String
    var body            : String
    let createdAt       : Date
    var location        : GeoPoint?
    var imageURL        : String?
    var userId          : String
    
    var coordinate: CLLocationCoordinate2D? {
        guard let loc = location else { return nil }
        return CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
    }
    
    
    static func createEmpty() -> Note {
        Note(
            id           : nil,
            title        : "",
            body         : "",
            createdAt    : Date(),
            location     : nil,
            userId       : ""
        )
    }
    
    // For Preview
    static let mock = Note(
        id           : "preview-id",
        title        : "Preview Note",
        body         : "This is a preview note",
        createdAt    : Date(),
        location     : GeoPoint(latitude: 37.7749, longitude: -122.4194),
        userId       : "preview-user"
    )
}
