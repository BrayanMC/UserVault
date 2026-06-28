//
//  LocationManager.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import CoreLocation
import Foundation

/// Manages Core Location services for the application.
///
/// Handles requesting location permissions and obtaining the device's
/// current coordinates. Publishes the location result via `@Published`
/// properties for SwiftUI observation.
///
/// ## Usage
/// ```swift
/// let manager = LocationManager()
/// manager.requestLocation()
/// // Observe manager.location for the result
/// ```
///
/// ## Properties
/// - `location`: The most recently obtained coordinates, or `nil`.
/// - `locationError`: The most recent location error, or `nil`.
///
/// ## Methods
/// - `requestLocation()`: Requests a single location update after
///   verifying or requesting WhenInUse authorization.
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    /// The most recently obtained coordinates.
    @Published var location: CLLocationCoordinate2D?

    /// The most recent location error.
    @Published var locationError: UserVaultError?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Requests a single location update.
    ///
    /// If authorization has not been determined, prompts the user for
    /// WhenInUse permission before requesting.
    func requestLocation() {
        locationError = nil
        location = nil

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationError = .locationDenied
        @unknown default:
            locationError = .locationDenied
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        location = coordinate
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = .locationDenied
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationError = .locationDenied
        default:
            break
        }
    }
}
