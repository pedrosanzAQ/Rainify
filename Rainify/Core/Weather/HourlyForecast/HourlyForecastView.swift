//
//  HourlyForecast4DaysView.swift
//  Rainify
//
//  Created by pedrosanz on 21/03/25.
//

import SwiftUI

struct HourlyForecastView: View {
    @Environment(AppSettings.self) private var appSettings
    var viewModel: HourlyForecastViewModel
    
    var body: some View {
        ContentBoxView(title: "Hourly Forecast", isOverlayStyle: true) {
            if !viewModel.upcomingHours.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16){
                        ForEach(viewModel.upcomingHours , id: \.time) { hour in
                            VStack(spacing: 5) {
                                Text(viewModel.label(for: hour))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.theme.dinamicText)
                                
                                
                                if let url = hour.condition.iconURL {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 38, height: 38)
                                        case .failure(_):
                                            Image(systemName: "Cloud")
                                    
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                
                                Text("\(appSettings.setTemperature(temp: hour.tempF))")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.theme.dinamicText)
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .frame(height: 80)
                    .padding(.vertical, 6)
                }
            } else {
                WithoutConnectionView()
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
    }
}

#Preview("Data"){
    let appSettings = AppSettings()
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let mockForecast = weather.forecast.forecastday
        HourlyForecastView(viewModel: HourlyForecastViewModel(forecast: mockForecast))
            .environment(appSettings)
    }
}

#Preview("NoData") {
    let appSettings = AppSettings()
    HourlyForecastView(viewModel: HourlyForecastViewModel(forecast: []))
        .environment(appSettings)
}


