//
//  MNLocationManager.swift
//  MoveoNotesApp
//
//  Created by elad on 03/07/2025.
//

import CoreLocation

@MainActor
class MNLocationManager: NSObject {
    static let shared = MNLocationManager()
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<EquatableCoordinate, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() async -> Bool {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
            return manager.authorizationStatus == .authorizedWhenInUse ||
                   manager.authorizationStatus == .authorizedAlways
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    func getCurrentLocation() async throws -> EquatableCoordinate {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
              manager.authorizationStatus == .authorizedAlways else {
            throw LocationError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
}

extension MNLocationManager: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            guard let continuation = self.continuation else { return }
            self.continuation = nil
            continuation.resume(returning: EquatableCoordinate(coordinate: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )))
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            guard let continuation = self.continuation else { return }
            self.continuation = nil
            continuation.resume(throwing: LocationError.locationUnavailable(error.localizedDescription))
        }
    }
}

enum LocationError: LocalizedError, Equatable {
    case permissionDenied
    case locationUnavailable(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location access denied. Please enable location services in Settings."
        case .locationUnavailable(let reason):
            return "Unable to get location: \(reason)"
        }
    }
}

