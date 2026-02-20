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

struct WeatherDailyForecastRow: View {
    @Environment(AppSettings.self) private var appSettings
    let day: String
    let iconURL: URL?
    let chanceOfRain: Int?
    let highTempF: Double?
    let lowTempF: Double?
    
    var body: some View {
        HStack(spacing: 8){
            Text(day)
                .foregroundColor(.theme.dinamicText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 43, alignment: .leading)
            
            VStack(spacing: 2){
                if iconURL != nil {
                    AsyncImage(url: iconURL!) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFit().frame(width: 25, height: 25)
                        case .empty:
                            ProgressView()
                        case .failure(_):
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                } else {
                    ProgressView()
                        .frame(width: 25, height: 25)
                }
                
                if let chanceOfRain = chanceOfRain {
                    Text("\(chanceOfRain)%")
                        .foregroundColor(.theme.dinamicText)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                
            }
            .frame(width: 60, alignment: .center)
            .padding(.trailing, 8)
            
            HStack(){
                if let lowTemp = lowTempF {
                    Text("\(appSettings.setIntTemperature(temp: lowTemp))")
                        .foregroundColor(.theme.dinamicText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                } else {
                    Text("--")
                        .foregroundColor(.theme.dinamicText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 6)
                    .padding(.horizontal, 8)
                
                if let highTemp = highTempF {
                    Text("\(appSettings.setIntTemperature(temp: highTemp))")
                        .foregroundColor(.theme.dinamicText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                } else {
                    Text("--")
                        .foregroundColor(.theme.dinamicText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 1)
    }
}

class DailyForecastViewModel {
    private(set) var Forecastdays: [Forecastday] = []
    
    init(forecastday: [Forecastday]){
        self.Forecastdays = forecastday
    }
    
    var hasData: Bool {
        return !Forecastdays.isEmpty
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
