//
//  ChanceShow.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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

