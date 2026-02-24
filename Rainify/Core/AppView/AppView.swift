//
//  AppView.swift
//  Rainify
//
//  Created by pedrosanz on 16/06/25.
//

// RAIZ

import SwiftUI

struct AppView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State var viewmodel: AppViewModel
    @State var appState: AppState = AppState()
    @State var appSettings: AppSettings = AppSettings()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if viewmodel.isAppReady {
                    AppViewBuilder(
                        showTabBar: appState.showTabBar,
                        tabbarView: {
                            TabbarView(viewmodel: TabbarViewModel(container: viewmodel.container))
                                .environment(appSettings)
                        },
                        onboardingView: {
                            WelcomeView(viewmodel: WelcomeViewModel(container: viewmodel.container, onFinished: {
                                appState.updateViewState(showTabBarView: true)
                            }))
                        }
                    )
                } else {
                    LauchReplicaView()
                }
            }
            .frame(
                width: geo.size.width,
                height: geo.size.height,
                alignment: .center
            )
            .task {
                await viewmodel.loadLocations()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    viewmodel.appBecomeActive()
                    
                case .inactive, .background:
                    viewmodel.onAppWentToBackground()
                    
                @unknown default:
                    break
                }
            }
            .environment(\.safeAreaInsets, geo.safeAreaInsets)
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()
            
            VStack(){
                ProgressView()
                    .padding(.bottom, 12)
                    .font(.headline)
                
                Text("Loading weather...")
                    .font(.subheadline)
            }
        }
    }
}

@Observable
class AppState {
    private(set) var showTabBar: Bool {
        didSet {
            UserDefaults.showTabbarView = showTabBar
        }
    }
    
    init(showTabBar: Bool = UserDefaults.showTabbarView) {
        self.showTabBar = showTabBar
    }
    
    func updateViewState(showTabBarView: Bool) {
        showTabBar = showTabBarView
    }
}

extension UserDefaults {
    private struct Keys {
        static let showTabbarView = "showTabbarView"
        static let temperatureUnit = "temperatureUnit"
    }
    
    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        }
        set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
    
    static var temperatureUnit: TemperatureUnit {
        get {
            guard let rawValue = standard.string(forKey: Keys.temperatureUnit),
                  let unit = TemperatureUnit(rawValue: rawValue) else {
                return TemperatureUnit.fahrenheit
            }
            return unit
        }
        set {
            standard.set(newValue.rawValue, forKey: Keys.temperatureUnit)
        }
    }
}

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

import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = .init()
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}



struct AppViewBuilder<TabBarView: View, WelcomeView: View>: View {
    var showTabBar: Bool
    @ViewBuilder var tabbarView: TabBarView
    @ViewBuilder var onboardingView: WelcomeView
    
    var body: some View {
        ZStack {
            if showTabBar {
                tabbarView
                    .transition(.move(edge: .trailing))
            } else {
                onboardingView
                    .transition(.move(edge: .leading))
            }
        }
    }
}



#Preview("FirstTime"){
    let container = DevPreview.shared.container
    container.register(LocationsPersistenceManager.self, service: LocationsPersistenceManager(service: MockLocationsPersistenceService(citis: [])))
    
    return AppView(viewmodel: AppViewModel(container: container), appState: AppState(showTabBar: false))
}

#Preview("SecondTime"){
    let container = DevPreview.shared.container
    container.register(LocationsPersistenceManager.self, service: LocationsPersistenceManager(service: MockLocationsPersistenceService()))
    return AppView(viewmodel: AppViewModel(container: DevPreview.shared.container), appState: AppState(showTabBar: true))
}
