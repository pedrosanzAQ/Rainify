//
//  AppViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

@Observable
@MainActor
class AppViewModel {
    let container: DependencyContainer
    private let weatherManager: WeatherManager
    private let locationsManager: LocationsPersistenceManager
    
    var topSafeArea: CGFloat = 0
    var isAppReady: Bool =  false
    
    private var refreshTask: Task<Void, Never>?
    
    init(container: DependencyContainer) {
        self.container = container
        self.weatherManager = container.resolve(WeatherManager.self)!
        self.locationsManager = container.resolve(LocationsPersistenceManager.self)!
    }
    
    func loadLocations() async {
        await weatherManager.loadLocationsCache()
        await locationsManager.loadPersistenceLocations()
        isAppReady = true
    }
    
    func appBecomeActive() {
        // load
        Task {
            await refreshWeather()
        }
        
        startAutoRefreash()
    }
    
    func onAppWentToBackground() {
        stopAutoRefresh()
    }
    
    private func startAutoRefreash() {
        guard refreshTask == nil else { return }
        
        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(600))
                await refreshWeather()
            }
        }
    }
    
    private func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    private func refreshWeather() async {
        for favorite in locationsManager.favorites {
            await weatherManager.loadWeather(locationId: favorite.id, lat: favorite.lat, lon: favorite.long)
        }
    }
    
}

