//
//  RealTimeManager.swift
//  Rainify
//
//  Created by pedrosanz on 02/02/26.
//

import Foundation
import CoreLocation

@Observable
@MainActor
class RealTimeManager: NSObject, @preconcurrency CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus
    var currentLocation: CLLocation?
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse ||
            authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        currentLocation = locations.first
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error:", error)
    }
}

@Observable
final class MockRealTimeManager {
    
    var authorizationStatus: CLAuthorizationStatus
    var currentLocation: CLLocation?
    
    init(
        authorizationStatus: CLAuthorizationStatus,
        currentLocation: CLLocation? = nil
    ) {
        self.authorizationStatus = authorizationStatus
        self.currentLocation = currentLocation
    }
    
    func requestPermission() {
        // Simulamos que el usuario acepta
        authorizationStatus = .authorizedAlways
        
        currentLocation = CLLocation(latitude: 19.4326, longitude: -99.1332)
    }
}
