//
//  ChanceShow.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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
//        forecastdays.day.dailyChanceOfSnow
        forecastdays.first?.day.dailyChanceOfRain
    }
    
    // i need the pastDailyChanceOfRain, so i need to save this forecastday
    // must be other manager
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

struct ChanceSnowView: View {
    var viewmodel: ChanceSnowViewModel
    
    var body: some View {
        ContentBoxView(title: "Snow") {
            if viewmodel.hasData {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(viewmodel.chanceOfSnow ?? 0)%" )
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.theme.primary)
                    
                    Text(viewmodel.snowDescription())
                        .font(.subheadline)
                        .foregroundColor(.theme.dinamicText)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.theme.primary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                WithoutConnectionView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview("Chance"){
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let forecastday = weather.forecast.forecastday
        ChanceSnowView(viewmodel: ChanceSnowViewModel(forecastday: forecastday))
            .frame(width: 180, height: 180)
    }
}

#Preview("NoChance"){
    ChanceSnowView(viewmodel: ChanceSnowViewModel(forecastday: []))
        .frame(width: 180, height: 180)
}

