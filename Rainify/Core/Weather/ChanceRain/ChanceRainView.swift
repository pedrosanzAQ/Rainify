//
//  ChanceRainView.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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
    }
}

#Preview("No data") {
    ChanceRainView(viewmodel: ChanceRainViewModel(forecastday: []))
    .frame(width: 180, height: 180)

}
