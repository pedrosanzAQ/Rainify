//
//  HourlyForecast4DaysView.swift
//  Rainify
//
//  Created by pedrosanz on 21/03/25.
//

import SwiftUI

struct HourlyForecastView: View {
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
                                
                                Text(String(format: "%.0f°C", hour.tempC))
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
//                .frame(height: 80)
//                .padding(.vertical, 6)
            } else {
                WithoutConnectionView()
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
//        .padding(.horizontal)
    }
}

// BUSINESS LOGIC VIEWMODEL
@MainActor
class HourlyForecastViewModel {
    private let forecastdays: [Forecastday]
    private(set) var upcomingHours: [Current] = []
    private(set) var pastHours: [Current] = []
    
    init(forecast: [Forecastday]) {
        self.forecastdays = forecast
        self.upcomingHours = getNext24hurs(Forecastdays: forecast)
    }
    
    private func getNext24hurs(Forecastdays: [Forecastday]) -> [Current] {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let recentDays = Forecastdays.prefix(2)
        
        let allHours = recentDays.flatMap{$0.hour}
        guard let startIndex = allHours.firstIndex(where: { hour in
            guard let hourString = hour.time else { return false }
            let comps = hourString.split(separator: " ")[1].split(separator: ":")
            if let hour = Int(comps[0]){
                return hour >= currentHour
            }
            return false
        }) else {
            return []
        }
        
        let endIndex = min(startIndex + 24, allHours.count)
        return Array(allHours[startIndex..<endIndex])

    }
    
    func label(for hour: Current) -> String {
        if let firstHour = upcomingHours.first, firstHour.time == hour.time {
            return "Now"
        } else {
            return hour.time?.hourFormat ?? "--:--"
        }
        
    }
    
    // return apple icon system acording the timeCondition
    // checar si es de dia mostrar con sol, sino con luna
    // checar cuando se va la luna para poner el simbolo normal
    
    // sun.max.fill     --- 113
    // cloud.sun.fill   --- 116
    // cloud.fill       --- 119, 122
    // cloud.fog.fill   --- 143
    // cloud.rain.fill  --- 176
    //
    
//    func icon(for hour: Current) -> String {
//        switch hour.condition.text.lowercased() {
//            case
//        }
//        return ""
//    }
}


#Preview("Data"){
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let mockForecast = weather.forecast.forecastday
//        let mockHours = weather.forecast.forecastday.first?.hour ?? []
        HourlyForecastView(viewModel: HourlyForecastViewModel(forecast: mockForecast))
    }
}

#Preview("NoData") {
    HourlyForecastView(viewModel: HourlyForecastViewModel(forecast: []))
}


