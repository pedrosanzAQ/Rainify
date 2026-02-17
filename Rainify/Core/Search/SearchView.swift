//
//  SearchView.swift
//  Rainify
//
//  Created by pedrosanz on 18/12/25.
//

import SwiftUI

@Observable
@MainActor
class SearchViewModel {
    let weatherManager: WeatherManager
    let locationsManager: LocationsPersistenceManager
    let container: DependencyContainer
    
    // this is state $viewmodel.search
    var searchText: String = "" {
        didSet { onSearchTextChanged() }
    }
    var selectedWeather: WeatherResponse?
    var isLoadingWeather: Bool = false
    
    private(set) var searchSuggestions: [StoredLocation] = []
    private var searchTask: Task<Void, Never>?
    
    init(container: DependencyContainer) {
        self.container = container
        self.locationsManager = container.resolve(LocationsPersistenceManager.self)!
        self.weatherManager = container.resolve(WeatherManager.self)!
    }
    
    var favorites: [StoredLocation] {
        locationsManager.favorites
    }
    
    var weathers: [Int: CachedWeather] {
        weatherManager.weatherCache
    }
    
    func onSearchTextChanged(){
        // Cancela búsqueda anterior si el usuario sigue escribiendo
        searchTask?.cancel()
        
        guard searchText.count > 2 else {
            searchSuggestions = []
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(for: .seconds(0.5))
            
            // Si la task fue cancelada, no continúa
            if Task.isCancelled { return }
            
            await getSuggestions()
        }
    }
    
    func loadSuggestionWeather(location: StoredLocation) async {
        isLoadingWeather = true
        
        do {
            selectedWeather = try await weatherManager.getWeatherByLocationSearch(location: location)
        } catch {
            selectedWeather = nil
        }
        
        isLoadingWeather = false
    }
    
    func getSuggestions() async {
        do {
            let results = try await weatherManager.getWeatherLocation(text: searchText)
            searchSuggestions = results
        } catch {
            searchSuggestions = []
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        searchSuggestions = []
    }
    
    func onFavoritesPressed(location: StoredLocation) {
//        withAnimation(.none) {
            locationsManager.addFavorites(location: location)
//        }
    }
    
    func isFavorite(_ location: StoredLocation) -> Bool {
        favorites.contains { $0.id == location.id }
    }
    
    func onDRecentsDeletePressed(location: StoredLocation) {
        locationsManager.removeRecents(location: location)
    }
    
    func onFavoritesDeletePressed(location: StoredLocation) {
        locationsManager.removeFavorites(location: location)
    }
}

struct SearchView: View {
    @Environment(TabbarViewModel.self) private var tabBarViewModel
    @State var viewmodel: SearchViewModel
    @State private var selectedLocation: StoredLocation? = nil
    @State private var selectedSuggestion: StoredLocation? = nil
    
//    var body: some View {
//        ZStack(){
//                if !viewmodel.favorites.isEmpty {
//                    List {
//                        Section("Favorites") {
//                            ForEach(viewmodel.favorites) { location in
//                                SearchRowView(weather: viewmodel.weathers[location.id]?.weather)
//                                .swipeActions(edge: .trailing, allowsFullSwipe: true){
//                                    Button {
//                                        viewmodel.onFavoritesDeletePressed(location: location)
//                                    } label: {
//                                        Image(systemName: "trash")
//                                    }
//                                    .tint(.red)
//                                }
//                                .listRowSeparator(.hidden)
//                                .listRowInsets(EdgeInsets(top:8, leading:0, bottom:8, trailing:0))
//                                .listRowBackground(Color.clear)
//                            }
//                        }
//                        .id("favorites-section")
//                    }
//                    .scrollContentBackground(.hidden)
//                    .scrollIndicators(.hidden)
//                    .background(Color.clear)
//                } else {
//                    VStack(spacing: 14){
//                        VStack(spacing: 8) {
//                            Text("No favorites")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                            
//                            Text("Search for a city and add it to see it here quickly")
//                                .font(.subheadline)
//                                .foregroundStyle(.secondary)
//                        }
//                        .multilineTextAlignment(.center)
//                        
//                        Image(systemName: "star")
//                            .font(.system(size: 40))
//                            .foregroundStyle(.secondary)
//                        
//                        Spacer()
//                    }
//                    .padding(.top)
//                }
//            }
//            .navigationTitle("Search")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "ellipsis")
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.large)
//            .searchable( text: $viewmodel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar algo"){
//                ForEach(viewmodel.searchSuggestions) { location in
//                    HStack(spacing: 0){
//                        Text(highlightedText(location.name, matching: viewmodel.searchText))
//                        
//                        Text(", \(location.country)")
//                            .foregroundStyle(.secondary)
//                    }
//                    .font(.headline)
//                    .searchCompletion(location.name)
//                    .onTapGesture {
//                        selectedSuggestion = location
//                    }
//                }
//                .listRowSeparator(.hidden)
//            }
//            .navigationDestination(item: $selectedLocation) { location in
//                Text(location.name)
//                    .font(.largeTitle)
//            }
//            .sheet(item: $selectedSuggestion) { location in
//                NavigationStack {
//                    Group {
//                        if viewmodel.isLoadingWeather {
//                            ProgressView()
//                        } else if let weather = viewmodel.selectedWeather {
//                            LocationView(
//                                viewmodel: LocationViewModel(
//                                    location: location,
//                                    weather: weather,
//                                    container: viewmodel.container
//                                ), isSheetPresented: true)
//                        } else {
//                            Text("Unable to load weather")
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                    .task {
//                        await viewmodel.loadSuggestionWeather(location: location)
//                    }
//                    .toolbar {
//                        ToolbarItem(placement: .topBarLeading) {
//                            Button("Cancel") {
//                                selectedSuggestion = nil
//                            }
//                        }
//                        
//                        if !viewmodel.isFavorite(location) {
//                            ToolbarItem(placement: .confirmationAction) {
//                                Button("Add") {
//                                    viewmodel.onFavoritesPressed(location: location)
//                                    viewmodel.clearSearch()
//                                    selectedSuggestion = nil
//                                }
//                            }
//                        }
//                    }
//                }
//                .presentationDetents([.large])
//            }
//    }
    
    var body: some View {
        ZStack {
            favoritesView
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewmodel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar algo"
        )
        {
            searchSuggestionsView
        }
        .sheet(item: $selectedSuggestion) { location in
            suggestionSheet(location)
        }
        .onChange(of: selectedSuggestion) { _, newValue in
            if newValue == nil {
                viewmodel.clearSearch()
            }
        }
    }

    
    // subviews
    @ViewBuilder
    var favoritesView: some View {
        if !viewmodel.favorites.isEmpty {
            List {
                Section("Favorites") {
                    ForEach(viewmodel.favorites) { location in
                        favoriteRow(location)
                            .onTapGesture {
                                tabBarViewModel.selectedLocationId = location.id
                                tabBarViewModel.selectedTab = .weather
                            }
                    }
                }
                .id("favorites-section")
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.clear)
        } else {
            emptyFavoritesView
        }
    }
    
    @ViewBuilder
    func favoriteRow(_ location: StoredLocation) -> some View {
        SearchRowView(weather: viewmodel.weathers[location.id]?.weather)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    viewmodel.onFavoritesDeletePressed(location: location)
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    var emptyFavoritesView: some View {
        VStack(spacing: 14) {
            VStack(spacing: 8) {
                Text("No favorites")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Search for a city and add it to see it here quickly")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            
            Image(systemName: "star")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.top)
    }
    
    func suggestionSheet(_ location: StoredLocation) -> some View {
        NavigationStack {
            Group {
                if viewmodel.isLoadingWeather {
                    ProgressView()
                } else if let weather = viewmodel.selectedWeather {
                    LocationView(
                        viewmodel: LocationViewModel(
                            location: location,
                            weather: weather,
                            container: viewmodel.container
                        ),
                        isSheetPresented: true
                    )
                } else {
                    Text("Unable to load weather")
                        .foregroundStyle(.secondary)
                }
            }
            .task {
                await viewmodel.loadSuggestionWeather(location: location)
            }
            .toolbar {
                sheetToolbar(location)
            }
        }
        .presentationDetents([.large])
    }
    
    @ToolbarContentBuilder
    func sheetToolbar(_ location: StoredLocation) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
                selectedSuggestion = nil
            }
        }
        
        if !viewmodel.isFavorite(location) {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    viewmodel.onFavoritesPressed(location: location)
//                    viewmodel.clearSearch()
                    selectedSuggestion = nil
                }
            }
        }
    }
    
    @ViewBuilder
    var searchSuggestionsView: some View {
        ForEach(viewmodel.searchSuggestions) { location in
            HStack(spacing: 0) {
                Text(highlightedText(location.name, matching: viewmodel.searchText))
                
                Text(", \(location.country)")
                    .foregroundStyle(.secondary)
            }
            .font(.headline)
            .searchCompletion(location.name)
            .onTapGesture {
                selectedSuggestion = location
            }
        }
        .listRowSeparator(.hidden)
    }
    
    func highlightedText(_ text: String, matching query: String) -> AttributedString {
        var attributed = AttributedString(text)
        
        // Color base gris
        attributed.foregroundColor = .gray
        
        // Si no hay query, todo normal
        guard !query.isEmpty else {
            attributed.foregroundColor = .primary
            return attributed
        }
        
        // Buscar rango donde coincide
        if let range = attributed.range(of: query, options: .caseInsensitive) {
            attributed[range].foregroundColor = .primary
            attributed[range].font = .headline.bold()
        }
        
        return attributed
    }
}

#Preview("cacheData"){
    let container = DevPreview.shared.container
    let tabbarVM = TabbarViewModel(container: container)
    NavigationStack {
        SearchView(viewmodel: SearchViewModel(container: container))
            .onAppear {
                Task {
                    await DevPreview.shared.weatherManager.loadLocationsCache()
                    await DevPreview.shared.locationManager.loadPersistenceLocations()
                }
            }
    }
    .environment(tabbarVM)
}
