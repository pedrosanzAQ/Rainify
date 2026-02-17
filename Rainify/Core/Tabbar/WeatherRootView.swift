//
//  WeatherRootView.swift
//  Rainify
//
//  Created by pedrosanz on 16/12/25.
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

import SwiftUI

struct WeatherRootView: View {
    @Environment(TabbarViewModel.self) private var tabbarViewModel
    @State private var selectedLocationId: Int?
    @Bindable var viewmodel: WeatherRootViewModel
    
    var bindableTabbar: Bindable<TabbarViewModel> {
        Bindable(tabbarViewModel)
    }
    
    var body: some View {
        ZStack {
            if viewmodel.favorites.isEmpty {
                emptyState
            } else if viewmodel.favorites.count == 1 {
                singleLocationView
            } else {
                pagedLocationsView
            }
            dotsView
        }
        .task {
            await viewmodel.loadWeathers()
        }
        .onChange(of: viewmodel.favorites) {
            // Si no hay selección aún, selecciona la primera/
            if tabbarViewModel.selectedLocationId == nil {
                tabbarViewModel.selectedLocationId = viewmodel.favorites.first?.id
            }
            
            // Si borraron la ciudad actual, ajusta selección
            if let selectedId = tabbarViewModel.selectedLocationId,
               !viewmodel.favorites.contains(where: { $0.id == selectedId }) {
                tabbarViewModel.selectedLocationId = viewmodel.favorites.first?.id
            }
        }
    }
}

// MARK: - Main Content
private extension WeatherRootView {
    
    private var dotsView: some View {
        guard viewmodel.favorites.count > 1 else { return AnyView(EmptyView()) }
        
        return AnyView(
            HStack(spacing: 8) {
                ForEach(viewmodel.favorites) { location in
                    Circle()
                        .fill(
                            location.id == tabbarViewModel.selectedLocationId
                            ? Color.primary
                            : Color.secondary.opacity(0.5)
                        )
                        .frame(width: 6, height: 6)
                }
            }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .zIndex(1)
        )
    }
    
    
    private var singleLocationView: some View {
        Group {
            if let location = viewmodel.favorites.first {
                LocationView(
                    viewmodel: LocationViewModel(
                        location: location,
                        weather: viewmodel.weathers[location.id]?.weather,
                        container: viewmodel.container
                    ),
                    isSheetPresented: false
                )
                .ignoresSafeArea()
            } else {
                EmptyView()
            }
        }
    }
    
    var pagedLocationsView: some View {
        //    @Environment
        TabView(selection: bindableTabbar.selectedLocationId) {
            ForEach(viewmodel.favorites) { location in
                LocationView(
                    viewmodel: LocationViewModel(
                        location: location,
                        weather: viewmodel.weathers[location.id]?.weather,
                        container: viewmodel.container
                    ),
                    isSheetPresented: false
                )
                .tag(location.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    private var emptyState: some View {
        ZStack {
            Color.clear
            
            VStack(spacing: 12){
                Spacer()
                
                VStack(spacing: 8){
                    //                    Text("No favorites location added")
                    Text("There are no favorite locations")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text("Search for a city and tap the star icon to keep track of its weather here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                }
                
                Button {
                    // Aquí pones la lógica para mostrar tu SearchView
                    // Ejemplo: isShowingSearch = true
                } label: {
                    Text("Find a location")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                Spacer()
            }
            
        }
    }

}

#Preview {
    let container = DevPreview.shared.container
    let tabbarVM = TabbarViewModel(container: container)
    NavigationStack {
        WeatherRootView(viewmodel: WeatherRootViewModel(container: container))
            .onAppear {
                Task {
                    await DevPreview.shared.weatherManager.loadLocationsCache()
                    await DevPreview.shared.locationManager.loadPersistenceLocations()
                }
            }
    }
    .environment(tabbarVM)

}
