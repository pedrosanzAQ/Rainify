//
//  WelcomeViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI
import CoreLocation

@Observable
@MainActor
class WelcomeViewModel {
    let realtimeManager: RealTimeManager
    let locationManager: LocationsPersistenceManager
    let weatherManager: WeatherManager
    
    var showPopup: Bool = false
    private let onFinished: () -> Void
    
    init(container: DependencyContainer, onFinished: @escaping () -> Void) {
        self.realtimeManager = container.resolve(RealTimeManager.self)!
        self.locationManager = container.resolve(LocationsPersistenceManager.self)!
        self.weatherManager = container.resolve(WeatherManager.self)!
        self.onFinished = onFinished
    }
    
    var authorizationStatus: CLAuthorizationStatus{
        realtimeManager.authorizationStatus
    }
    
    func onGetStartedPressed() {
        showPopup = true
    }
    
    func requestLocationPermission() {
        realtimeManager.requestPermission()
    }
    
    func onAuthorizationChanged() async {
        let status = realtimeManager.authorizationStatus
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        
        guard let location = await realtimeManager.requestLocation() else {
            return
        }
        
        
        showPopup = false
        await saveCurrentLocation(location)
        onFinished()
    }
    
    private func saveCurrentLocation(_ location: CLLocation) async {
        guard let response = try? await weatherManager.getCurrentLocation(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        ) else { return }
        
        locationManager.addFavorites(location: response)
        await weatherManager.loadWeather(locationId: response.id, lat: response.lat, lon: response.long)
    }
}


