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
class RealTimeManager {
    
    private let service: LocationService
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var currentLocation: CLLocation?
    
    
    init(service: LocationService) {
        self.service = service
        
        self.authorizationStatus = service.authorizationStatus
        self.currentLocation = service.currentLocation
    }
    
    func requestPermission() {
        service.requestPermission()

    }
    
    func refreshLocation() {
        service.requestLocation()
    }
}


@MainActor
protocol LocationService: AnyObject{
    
    var authorizationStatus: CLAuthorizationStatus { get }
    var currentLocation: CLLocation? { get }
    
    func requestPermission()
    func requestLocation()
}

@Observable
final class MockRealTimeService: LocationService {
    
    var authorizationStatus: CLAuthorizationStatus
    var currentLocation: CLLocation?
    
    init(
        authorizationStatus: CLAuthorizationStatus = .notDetermined,
        currentLocation: CLLocation? = nil
    ) {
        self.authorizationStatus = authorizationStatus
        self.currentLocation = currentLocation
    }
    
    
    func requestPermission() {
        authorizationStatus = .authorizedWhenInUse
        currentLocation = CLLocation(latitude: 19.4326, longitude: -99.1332)
    }
    
    func requestLocation() {
    }
}


import CoreLocation

@Observable
final class RealTimeService: NSObject, LocationService, @MainActor CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var currentLocation: CLLocation?
    
    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            
            if authorizationStatus == .authorizedWhenInUse ||
                authorizationStatus == .authorizedAlways {
                requestLocation()
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        Task { @MainActor in
            self.currentLocation = locations.first
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        Task { @MainActor in
            print("Location error:", error.localizedDescription)
            self.currentLocation = nil
        }
    }
}
