//
//  WeatherRootViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

@Observable
@MainActor
class WeatherRootViewModel {
    var locationsManager: LocationsPersistenceManager
    var weatherManager: WeatherManager
    var container: DependencyContainer
    
    private var didLoad = false
    
    init(container: DependencyContainer) {
        self.locationsManager = container.resolve(LocationsPersistenceManager.self)!
        self.weatherManager = container.resolve(WeatherManager.self)!
        self.container = container
    }
    
    var favorites: [StoredLocation] {
        locationsManager.favorites
    }
    
    var weathers: [Int: CachedWeather] {
        weatherManager.weatherCache
    }
    
    func loadWeathers() async {
        for favorite in favorites {
            await weatherManager
                .loadWeather(
                    locationId: favorite.id,
                    lat: favorite.lat,
                    lon: favorite.long
                )
        }
    }
    
    func weather(for locationId: Int) -> WeatherResponse? {
        weatherManager.weatherCache[locationId]?.weather
    }
}
