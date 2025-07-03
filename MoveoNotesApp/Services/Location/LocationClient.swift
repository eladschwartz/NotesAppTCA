//
//  LocationClient.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import ComposableArchitecture
import CoreLocation

struct LocationClient {
    var requestPermission: () async -> Bool
    var getCurrentLocation: () async throws -> EquatableCoordinate
}

extension LocationClient: DependencyKey {
    static let liveValue: LocationClient = LocationClient(
        requestPermission: {
            await MNLocationManager.shared.requestPermission()
        },
        getCurrentLocation: {
            try await MNLocationManager.shared.getCurrentLocation()
        }
    )
}



extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
