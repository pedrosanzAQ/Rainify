//
//  RainifyApp.swift
//  Rainify
//
//  Created by pedrosanz on 15/03/25.
//

import SwiftUI
import CoreLocation

@main
struct RainifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if let container = appDelegate.dependencies?.container {
                AppView(viewmodel: AppViewModel(container: container))
            } else {
                ProgressView()
            }
        }
    }
}

struct EnvironmentBuilderView<Content: View> : View {
    let appDelegate: AppDelegate
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .environment(appDelegate.dependencies.container)
    }
}

@MainActor
class DeviceInfo: ObservableObject {
    @Published var screenWidthInPixels: CGFloat = 0

    init() {
        self.screenWidthInPixels = UIScreen.main.bounds.width
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dependencies = Dependencies()
        return true
    }
}

@Observable
@MainActor
class DependencyContainer {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, service: T) {
        let key = "\(type)"
        services[key] = service
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return services[key] as? T
    }
}

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

