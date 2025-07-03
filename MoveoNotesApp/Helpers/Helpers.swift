//
//  Helpers.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import CoreLocation
import MapKit
import SwiftUI

extension Binding {
    func sending<Action>(_ action: @escaping (Value) -> Action) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

// State vars in TCA must conform to Equatable
struct EquatableCoordinate: Equatable {
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}


struct MapRegion: Equatable, Codable {
    let centerLatitude: Double
    let centerLongitude: Double
    let latitudeDelta: Double
    let longitudeDelta: Double
    
    init(region: MKCoordinateRegion) {
        self.centerLatitude = region.center.latitude
        self.centerLongitude = region.center.longitude
        self.latitudeDelta = region.span.latitudeDelta
        self.longitudeDelta = region.span.longitudeDelta
    }
    
    init(center: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        self.centerLatitude = center.latitude
        self.centerLongitude = center.longitude
        self.latitudeDelta = span.latitudeDelta
        self.longitudeDelta = span.longitudeDelta
    }
    
    var mkCoordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
    }
}
