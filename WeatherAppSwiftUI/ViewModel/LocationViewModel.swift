//
//  LocationViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 20/01/2025.
//

import CoreLocation
import Foundation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    private let locationManager = CLLocationManager()
    private var retryCount = 0
    private let maxRetryCount = 5
    private var locationUpdateTimer: Timer?
    private static let locationTimeout: TimeInterval = 30.0 // 30 seconds

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Slightly less accurate but quicker
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        startLocationUpdates()
    }
    
    func startLocationUpdates() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Delegate methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            startLocationTimeoutTimer()
        case .restricted, .denied:
            handleAuthorizationError()
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Cancel the timeout timer if we get a location update
        locationUpdateTimer?.invalidate()
        
        // Only update if the accuracy is reasonable or if no previous location was set
        if userLocation == nil || location.horizontalAccuracy <= 100 { // 100 meters accuracy as threshold
            DispatchQueue.main.async {
                self.userLocation = location
            }
            // Optionally stop updating if you got a good location
            // locationManager.stopUpdatingLocation()
        } else {
            print("Location accuracy not sufficient: \(location.horizontalAccuracy) meters")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        handleLocationError()
    }
    
    // New methods
    
    private func startLocationTimeoutTimer() {
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: Self.locationTimeout, repeats: false) { [weak self] _ in
            self?.handleLocationTimeout()
        }
    }
    
    private func handleLocationTimeout() {
        print("Location timeout occurred")
        locationManager.stopUpdatingLocation()
        // Here you could decide to use a less accurate location or inform the user
        if userLocation == nil {
            // Fallback to a less accurate location if possible
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    private func handleAuthorizationError() {
        if retryCount < maxRetryCount {
            retryCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.locationManager.requestWhenInUseAuthorization()
            }
        } else {
            print("Max retry count reached for location authorization")
        }
    }
    
    private func handleLocationError() {
        if retryCount < maxRetryCount {
            retryCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.locationManager.startUpdatingLocation()
            }
        } else {
            print("Max retry count reached for location updates")
            // Optionally reset location services here
            resetLocationServices()
        }
    }
    
    private func resetLocationServices() {
        locationManager.stopUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Short delay before re-enabling
            self.retryCount = 0
            self.locationManager.startUpdatingLocation()
        }
    }
}
