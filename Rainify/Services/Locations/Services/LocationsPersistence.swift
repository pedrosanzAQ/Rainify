//
//  LocationsPerssitence.swift
//  Rainify
//
//  Created by pedrosanz on 08/01/26.
//
//
import Foundation

struct StoredLocation: Identifiable, Codable, Sendable, Hashable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let long: Double
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        [
            StoredLocation(id: 1, name: "Mexico City", region: "The Federal District", country: "Mexico", lat: 23.6345, long: 102.5528),
            StoredLocation(id: 2, name: "London", region: "City of London, Greater London", country: "United Kingdom", lat: 51.5074, long: -0.1278),
            StoredLocation(id: 3, name : "Potosí", region: "Potosi", country: "Boliivia", lat: 19.5723, long: 65.7550),
            StoredLocation(id: 4, name: "Queenstown", region: "Tasmania", country: "Australia", lat: 45.0312, long: 168.6626),
            StoredLocation(id: 5, name: "Chaouen", region: "", country: "Morocco", lat: 35.1688, long: 5.2636),
        ]
    }
}
 
protocol LocationsService: Sendable {
    func saveRecents(cities: [StoredLocation]) throws
    func loadRecents() async-> [StoredLocation]
    func saveFavorites(cities: [StoredLocation])  throws
    func loadFavorites() async -> [StoredLocation]
}

struct MockLocationsPersistenceService: LocationsService {
    
    let citis: [StoredLocation]
    let delay: Double
    
    init(citis: [StoredLocation] = StoredLocation.mocks, delay: Double = 0.0) {
        self.citis = citis
        self.delay = delay
    }
    
    func saveRecents(cities: [StoredLocation]) throws{
        
    }
    
    func saveFavorites(cities: [StoredLocation])  throws {
    }
    
    func loadRecents() async -> [StoredLocation] {
        return citis.shuffled()
    }
        
    func loadFavorites() async -> [StoredLocation] {
        let favs = Array(citis.prefix(3))
        return favs
    }
}

struct LocalLocationPersistenceService: LocationsService {
    private let favoritesFolder: String = "favorites"
    private let recentsFolder: String = "recents"
    
    private var path: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("locations")
    }
    
    private func fileURL(fileName: String) -> URL {
        return path.appendingPathComponent(fileName)
    }
    
    func saveRecents(cities: [StoredLocation]) throws{
        try FileManager.default.save(cities, to: fileURL(fileName: recentsFolder))
    }
    
    func loadRecents() async -> [StoredLocation] {
        return (try? FileManager.default.load([StoredLocation].self, from: fileURL(fileName: recentsFolder))) ?? []
    }
    
    func saveFavorites(cities: [StoredLocation]) throws {
        createFolderIfNeeded()
        try FileManager.default.save(cities, to: fileURL(fileName: favoritesFolder))
    }
    
    func loadFavorites() async -> [StoredLocation] {
        return (try?FileManager.default.load([StoredLocation].self, from: fileURL(fileName: favoritesFolder))) ?? []
    }
    
    private func createFolderIfNeeded() {
        if !FileManager.default.fileExists(atPath: path.path) {
            try? FileManager.default.createDirectory(
                at: path,
                withIntermediateDirectories: true
            )
        }
    }

}

@MainActor
@Observable
class LocationsPersistenceManager {
    private let service: LocationsService
    // in memory becouse two clases use them
    private(set) var recents: [StoredLocation] = []
    private(set) var favorites: [StoredLocation] = []
    
    init(service: LocationsService){
        self.service = service
    }
    
    // We gonna call it in root aplication
    func loadPersistenceLocations() async {
        recents = await service.loadRecents()
        favorites = await service.loadFavorites()
    }

    
    func addRecents(location: StoredLocation) {
        recents.removeAll { $0.id == location.id }
        
        recents.insert(location, at: 0)
        
        if recents.count > 8 {
            recents = Array(recents.prefix(8))
        }
        
        Task.detached { [recents, service] in
            try? service.saveRecents(cities: recents)
        }
    }
    
    func addFavorites(location: StoredLocation) {
        
        recents.removeAll { $0.id == location.id }
        favorites.removeAll { $0.id == location.id }
        favorites.append(location)
        
//        let currentRecents = recents
        let currentFavorites = favorites
        
        Task.detached {
//            try? self.service.saveRecents(cities: currentRecents)
            try? self.service.saveFavorites(cities: currentFavorites)
        }
    }
    
    func removeFavorites(location: StoredLocation) {
        favorites.removeAll { $0.id == location.id }
        
        Task.detached { [favorites, service] in
            try? service.saveFavorites(cities: favorites)
        }
    }
    
    func removeRecents(location: StoredLocation) {
        recents.removeAll { $0.id == location.id }
        
        Task.detached { [recents, service] in
            try? service.saveRecents(cities: recents)
        }
    }
}
