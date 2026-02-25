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
    
//    var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    var currentLocation: CLLocation?
    
    
    init(service: LocationService) {
        self.service = service
        
//        self.authorizationStatus = service.authorizationStatus
//        self.currentLocation = service.currentLocation
    }
    var authorizationStatus: CLAuthorizationStatus {
        service.authorizationStatus
    }
    
    var currentLocation: CLLocation? {
        service.currentLocation
    }
    
    func requestPermission() {
        service.requestPermission()

    }
    
    func requestLocation() async -> CLLocation? {
        await service.requestLocation()
    }
}


@MainActor
protocol LocationService: AnyObject{
    
    var authorizationStatus: CLAuthorizationStatus { get }
    var currentLocation: CLLocation? { get }
    
    func requestPermission()
    func requestLocation() async -> CLLocation?
}

@Observable
final class MockRealTimeService: LocationService {
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var currentLocation: CLLocation? = nil
    
    func requestPermission() {
        authorizationStatus = .authorizedAlways
        currentLocation = CLLocation(latitude: 19.4326, longitude: -99.1332)
    }
    
    func requestLocation() async -> CLLocation? {
        currentLocation
    }
}



@Observable
final class RealTimeService: NSObject, LocationService, @MainActor CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?
    
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
    
    func requestLocation() async -> CLLocation?{
        await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            
//            if authorizationStatus == .authorizedWhenInUse ||
//                authorizationStatus == .authorizedAlways {
//                await requestLocation()
//            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let location = locations.first
        currentLocation = location
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
}
