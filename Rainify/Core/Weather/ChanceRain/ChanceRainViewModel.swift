//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

@MainActor
class ChanceRainViewModel {
    //    private(set) var chanceOfRain: Int?
    var forecastday: [Forecastday] = []
    private(set) var pastDailyChanceofRain: Int = 0
    var isLoading: Bool = true
    
    init(forecastday: [Forecastday]) {
        self.forecastday = forecastday
    }
    
    var chanceOfRain: Int {
        return forecastday.first?.day.dailyChanceOfRain ?? 0
    }
    
    func rainDescription() -> String {
        if chanceOfRain > pastDailyChanceofRain {
            return "More than yesterday, take an umbrella ☂️"
        } else if chanceOfRain < pastDailyChanceofRain {
            return "Less than yesterday, you might be fine 🌤️"
        } else {
            return "Same as yesterday, stay alert  🌧️"
        }
    }
}

