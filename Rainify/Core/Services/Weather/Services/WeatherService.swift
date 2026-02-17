//
//  WeatherService.swift
//  Rainify
//
//  Created by pedrosanz on 03/06/25.
//
import SwiftUI

struct WeatherSearchResponse: Decodable, Sendable{
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let url: String
    
    static var mocksResponse: [WeatherSearchResponse] {
        [
            WeatherSearchResponse(
                id: 1788272,
                name: "Arequipa",
                region: "Arequipa",
                country: "Peru",
                lat: -16.4,
                lon: -71.54,
                url: "arequipa-arequipa-peru"
            ),
            WeatherSearchResponse(
                id: 2653892,
                name: "Arlington",
                region: "Texas",
                country: "United States of America",
                lat: 32.74,
                lon: -97.11,
                url: "arlington-texas-united-states-of-america"
            ),
            WeatherSearchResponse(
                id: 758834,
                name: "Argenteuil",
                region: "Ile-de-France",
                country: "France",
                lat: 48.95,
                lon: 2.25,
                url: "argenteuil-ile-de-france-france"
            )
        ]
    }
}

protocol WeatherService: Sendable {
    func getCurrentLocation(lat: Double, lon: Double) async throws -> StoredLocation
    func getWeatherLocation(text: String) async throws -> [StoredLocation]
    func loadWeather(lat: Double, lon: Double) async throws -> WeatherResponse?
}

struct MockWeatherService: WeatherService {
    let weather: WeatherResponse?
    let locations: [StoredLocation]
    let delay: Double
    
    init(fileName: String? = "MockWeatherResponse.json", delay: Double = 0.0) {
//        let weatherResponse: WeatherResponse? = Bundle.main.decode("MocWeatherResponse.json")
        
        self.locations = StoredLocation.mocks.shuffled()
        self.weather = WeatherResponse.mock
        self.delay = delay
    }
    
    func getCurrentLocation(lat: Double, lon: Double) async throws -> StoredLocation {
        let location = StoredLocation(id: 42, name: "Lauterbrunnen", region: "Bern", country: "Switzerland", lat: 46.5935, long: 7.9090)
        return location
    }
    
    func getWeatherLocation(text: String) async throws -> [StoredLocation] {
        return locations.shuffled()
    }
    
    func loadWeather(lat: Double, lon: Double) async throws -> WeatherResponse? {
        return weather
    }
    
}

struct APIWeatherService: WeatherService {
    func getCurrentLocation(lat: Double, lon: Double) async throws -> StoredLocation {
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(Keys.WeatherApiKey)&q=\(lat),\(lon)"
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        
        let decoded = try JSONDecoder().decode([WeatherSearchResponse].self, from: data)
        
        guard let location = decoded.first else {
            throw URLError(.badServerResponse)
        }
        
        return StoredLocation(
            id: location.id,
            name: location.name,
            region: location.region,
            country: location.country,
            lat: location.lat,
            long: location.lon
        )
    }
    
    func getWeatherLocation(text: String) async throws -> [StoredLocation] {
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(Keys.WeatherApiKey)&q=\(text)"
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        
        let decoded = try JSONDecoder().decode([WeatherSearchResponse].self, from: data)
        
        return decoded.map {
            StoredLocation(
                id: $0.id,
                name: $0.name,
                region: $0.region,
                country: $0.country,
                lat: $0.lat,
                long: $0.lon
            )
        }
    }
    
    func loadWeather(lat: Double, lon: Double) async throws -> WeatherResponse? {
        let query = "\(lat),\(lon)"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(Keys.WeatherApiKey)&q=\(query)&days=10&aqi=yes&alerts=no"
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}


struct CachedWeather: Codable{
    let locationId: Int
    let weather: WeatherResponse?
    let lastUpdated: Date
    
    static var mocks: [Self] {
        
        return [
            CachedWeather(locationId: 1, weather: WeatherResponse.mocks[1], lastUpdated: Date()),
            CachedWeather(locationId: 2, weather: WeatherResponse.mocks[0], lastUpdated: Date()),
            CachedWeather(locationId: 3, weather: WeatherResponse.mocks[2], lastUpdated: Date()),
        ]
    }
}

protocol CachedWeatherService: Sendable {
    func loadCache() async -> [Int: CachedWeather]
    func saveCache(_ cache: [Int: CachedWeather]) async
}

struct MockCachedWeatherPersistence: CachedWeatherService {
    let cachedCities: [Int: CachedWeather]
    
    init(initial: [CachedWeather] = CachedWeather.mocks) {
        self.cachedCities = Dictionary(
            uniqueKeysWithValues: initial.map { ($0.locationId, $0) }
        )
    }
    
    func loadCache() async -> [Int : CachedWeather] {
        return cachedCities
    }
    
    func saveCache(_ cache: [Int : CachedWeather]) async {
        
    }
}

struct LocalCachedWeatherPersistence: CachedWeatherService {
    func loadCache() async -> [Int : CachedWeather] {
        return (try? FileManager.default.load([Int: CachedWeather].self, from: path)) ?? [:]
    }
    
    func saveCache(_ cache: [Int : CachedWeather]) async {
        try? FileManager.default.save(cache, to: path)
    }
    
    private var path: URL {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cache.appendingPathComponent("weatherCache")
    }
}
