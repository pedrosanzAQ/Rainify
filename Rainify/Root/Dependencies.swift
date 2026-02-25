//
//  Dependencies.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//

@MainActor
struct Dependencies {
    let container: DependencyContainer
    let weatherManager: WeatherManager
    let locationManager: LocationsPersistenceManager
    let realTimeManager: RealTimeManager
    
    init() {
        self.weatherManager = WeatherManager(weatherService: APIWeatherService(), cachedService: LocalCachedWeatherPersistence())
        self.locationManager = LocationsPersistenceManager(service: LocalLocationPersistenceService())
        self.realTimeManager = RealTimeManager(service: RealTimeService())
        
        let container = DependencyContainer()
        container.register(WeatherManager.self, service: weatherManager)
        container.register(LocationsPersistenceManager.self, service: locationManager)
        container.register(RealTimeManager.self, service: realTimeManager)
        self.container = container
    }
    
}

@MainActor
class DevPreview {
    static let shared = DevPreview()
    
    let container: DependencyContainer
    let weatherManager: WeatherManager
    let locationManager: LocationsPersistenceManager
    let mockRealTimeManager: RealTimeManager
    
    init() {
        self.weatherManager = WeatherManager(weatherService: MockWeatherService(), cachedService: MockCachedWeatherPersistence())
        self.locationManager = LocationsPersistenceManager(service: MockLocationsPersistenceService())
        self.mockRealTimeManager = RealTimeManager(service: MockRealTimeService())
        
        let container = DependencyContainer()
        container.register(WeatherManager.self, service: weatherManager)
        container.register(LocationsPersistenceManager.self, service: locationManager)
        container.register(RealTimeManager.self, service: mockRealTimeManager)
        self.container = container
    }
}

