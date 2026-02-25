//
//  WeatherManager.swift
//  Rainify
//
//  Created by pedrosanz on 04/06/25.
//
import SwiftUI

@Observable
@MainActor
class WeatherManager {
    private let weatherService: WeatherService
    private let cachedService: CachedWeatherService
    private let cacheLifetime: TimeInterval = 10 * 60
    
    var weatherCache: [Int: CachedWeather] = [:]
    
    var weather: WeatherResponse?
    
    init(weatherService: WeatherService, cachedService: CachedWeatherService) {
        self.weatherService = weatherService
        self.cachedService = cachedService
    }
    
    func loadLocationsCache() async {
        weatherCache = await cachedService.loadCache()
    }
    
    func getWeatherLocation(text: String) async throws -> [StoredLocation] {
        return try await weatherService.getWeatherLocation(text: text)
    }
    
    func getCurrentLocation(lat: Double, lon: Double) async throws -> StoredLocation {
        return try await weatherService.getCurrentLocation(lat: lat, lon: lon)
    }
    
    func loadWeather(locationId: Int, lat: Double, lon: Double) async {
        // si hay cache
        if let cached = weatherCache[locationId] {
            // edad del cache
            let elapsed = Date().timeIntervalSince(cached.lastUpdated)
            
            // cache 8min < 10min
            if elapsed < cacheLifetime {
                return
            }
        }
        
        // sino
        guard let freshWeather = try? await weatherService.loadWeather(lat: lat,lon: lon) else {
            return
        }
        
        let cacheObj = CachedWeather(
            locationId: locationId,
            weather: freshWeather,
            lastUpdated: Date()
        )
        
        weatherCache[locationId] = cacheObj
        await cachedService.saveCache(weatherCache)
    }
    
    func getWeatherByLocationSearch(location: StoredLocation) async throws -> WeatherResponse? {
        if let cached = weatherCache[location.id] {
            let elapsed = Date().timeIntervalSince(cached.lastUpdated)
            
            if elapsed < cacheLifetime {
                return cached.weather
            }
        }
        
        let freashWeather = try? await weatherService.loadWeather(lat: location.lat, lon: location.long)
        
        let cacheObj = CachedWeather (
            locationId: location.id,
            weather: freashWeather,
            lastUpdated: Date()
        )
        
        weatherCache[location.id] = cacheObj
        await cachedService.saveCache(weatherCache)
        
        return freashWeather
    }
}
