//
//  ChanceRainView.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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
    
    // i need the pastDailyChanceOfRain, so i need to save this forecastday
    // must be other manager
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

struct ChanceRainView: View {
    var viewmodel: ChanceRainViewModel
    
    var body: some View {
        ContentBoxView(title: "Rain") {
            if viewmodel.forecastday.isEmpty {
                WithoutConnectionView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(alignment: .leading, spacing: 20){
                    if !viewmodel.forecastday.isEmpty {
                        Text("\(viewmodel.chanceOfRain)%")
                            .foregroundColor(.theme.primary)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        
                        Text(viewmodel.rainDescription())
                            .foregroundColor(.theme.primary)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
//            .padding(.vertical, 8)
        }

    }
}

#Preview("Data") {
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let forecastday = weather.forecast.forecastday
        ChanceRainView(viewmodel: {
            let vm = ChanceRainViewModel(forecastday: forecastday)
            vm.isLoading = false
            return vm
        }())
        .frame(width: 180, height: 180)
//        .frame(width: 0, height: 0)
    }
}

#Preview("No data") {
    ChanceRainView(viewmodel: ChanceRainViewModel(forecastday: []))
    .frame(width: 180, height: 180)

}
