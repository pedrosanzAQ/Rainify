//
//  DailyForecastView.swift
//  Rainify
//
//  Created by pedrosanz on 17/05/25.
//

import SwiftUI

struct DailyForecastView: View {
    var viewmodel: DailyForecastViewModel
    
    var body: some View {
        ContentBoxView(title: "10 Day Forecast") {
            if viewmodel.hasData {
                VStack(spacing: 12){
                    ForEach(viewmodel.Forecastdays.indices, id: \.self) { index in
                        let forecasteday = viewmodel.Forecastdays[index]
                        
                        let dayString: String = {
                            if index == 0 {
                                return "Today"
                            } else {
                                return forecasteday.date.weekdayName
                            }
                        }()
                        
                        WeatherDailyForecastRow(
                            day: dayString,
                            iconURL: forecasteday.day.condition.iconURL,
                            chanceOfRain: forecasteday.day.dailyChanceOfRain,
                            highTempF: forecasteday.day.maxtempF,
                            lowTempF: forecasteday.day.mintempF
                        )
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal, -4)
                    }
                }
            } else {
                VStack{
                    WithoutConnectionView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    
                    ForEach(0..<9, id: \.self) { offset in
                        if let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) {
                            
                            let weekday = date.formatted(.dateTime.weekday(.abbreviated)).capitalized
                            
                            WeatherDailyForecastRow(
                                day: weekday,   // <- YA RECIBE "Lun", "Mar", etc.
                                iconURL: nil,
                                chanceOfRain: nil,
                                highTempF: nil,
                                lowTempF: nil
                            )
                            .padding(8)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
//        .padding(.horizontal)
    }
}

#Preview("MockData") {
    let appSettings = AppSettings()
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let mockForecastdays = weather.forecast.forecastday
        DailyForecastView(viewmodel: DailyForecastViewModel(forecastday: mockForecastdays))
            .padding(.horizontal)
            .environment(appSettings)
    }
}

#Preview("NoData") {
    let appSettings = AppSettings()
    DailyForecastView(viewmodel: DailyForecastViewModel(forecastday: []))
        .environment(appSettings)
}
