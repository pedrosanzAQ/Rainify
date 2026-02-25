//
//  MockWeatherService.swift
//  Rainify
//
//  Created by pedrosanz on 03/06/25.
//

import Foundation
//
//struct MockWeatherService: WeatherService {
//    
//    let weather: WeatherResponse?
//    let delay: Double
//    
//    init(fileName: String? = "MockWeatherResponse.json", delay: Double = 0.0) {
//        self.weather = Bundle.main.decode(fileName ?? "")
//        self.delay = delay
//    }
//    
//    func getWeather(location: String) async throws -> WeatherResponse? {
//        try await Task.sleep(nanoseconds: .init(delay * 1_000_000_000))
//        return weather
//    }
//
//}
