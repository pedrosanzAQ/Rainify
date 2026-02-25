//
//  LocationViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//
//import SwiftfUI
import SwiftUI

@Observable
@MainActor
class LocationViewModel {
    private(set) var weatherResponse: WeatherResponse?
    private let locationsManager: LocationsPersistenceManager
    private var location: StoredLocation
    
    var topSafeArea: CGFloat = 59
    
    init(location: StoredLocation, weather: WeatherResponse?, container: DependencyContainer) {
        self.weatherResponse = weather
        self.location = location
        self.locationsManager = container.resolve(LocationsPersistenceManager.self)!
        
    }
    
    var isPinned: Bool {
        locationsManager.favorites.contains(where: { $0.id == location.id })
    }
    
    var hasData: Bool {
        return weatherResponse != nil
    }
    
    var forecastday: [Forecastday]? {
        return weatherResponse?.forecast.forecastday
    }
    
    var current: Current? {
        return weatherResponse?.current
    }
    
    var weather: WeatherResponse? {
        return self.weatherResponse
    }
    
    // MARK: -- ACCESS VARIABLES
    
    var locationName: String? {
        return weatherResponse?.location.name
    }
    
    var condition: String? {
        return weatherResponse?.current.condition.text
    }
    
    var humidity: Int? {
        return weatherResponse?.current.humidity
    }
    
    func toggleFavorite() {
        if isPinned {
            locationsManager.removeFavorites(location: location)
        } else {
            locationsManager.addFavorites(location: location)
        }
    }
}
