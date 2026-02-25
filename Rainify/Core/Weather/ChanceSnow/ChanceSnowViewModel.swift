//
//  ChanceSnowViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//

class ChanceSnowViewModel {
    private var forecastdays: [Forecastday] = []
    private var pastDailyChanceofSnow: Int = 0
    init(forecastday: [Forecastday]) {
        self.forecastdays = forecastday
    }
    
    var hasData: Bool {
        return !forecastdays.isEmpty
    }
    
    var chanceOfSnow: Int? {
        forecastdays.first?.day.dailyChanceOfRain
    }
    
    func snowDescription() -> String {
        guard let chanceOfSnow else { return "NoData" }
        
        if chanceOfSnow > pastDailyChanceofSnow {
            return "Colder than yesterday, higher chance of snow ❄️"
        } else if chanceOfSnow < pastDailyChanceofSnow {
            return "Slightly warmer than yesterday, less chance of snow 🌤️"
        } else {
            return "Same snow chance as yesterday, stay warm ☃️"
        }
    }
}
