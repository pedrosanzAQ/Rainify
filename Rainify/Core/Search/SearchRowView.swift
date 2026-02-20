//
//  SearchRowView.swift
//  Rainify
//
//  Created by pedrosanz on 19/01/26.
//

import SwiftUI

struct SearchRowView: View {
    @Environment(AppSettings.self) private var appSettings
    let weather: WeatherResponse?
    private let locationName: String?
    private let temperatureF: Double?
    private let highTempF: Double?
    private let lowTempF: Double?
    private let condition: String?
    private let hour: String?
    
    private let backgroundGradient: LinearGradient
    
    init(
        weather: WeatherResponse?
    ) {
        self.weather = weather
        self.locationName = weather?.location.name
        self.temperatureF = weather?.current.tempF
        self.highTempF = weather?.forecast.forecastday.first?.day.maxtempF
        self.lowTempF = weather?.forecast.forecastday.first?.day.mintempF
        self.condition = weather?.current.condition.text
        self.hour = weather?.current.lastUpdated
        self.backgroundGradient = SearchRowView.makeGradient(hour: hour ?? "00:00")
    }
    
    var body: some View {
        VStack{
           HStack {
               VStack(alignment: .leading){
                   Text(locationName ?? "Unknomwn Location")
                       .font(.title)
                   Text(hour?.extractHourMinute ?? "00:00")
                       .font(.caption)
               }
               
               Spacer()
               
               Text(appSettings.setTemperature(temp: temperatureF ?? 0))
                   .padding(.trailing)
                   .font(.title)
            }
           .padding(.bottom, 4)
            
            HStack {
                Text(condition ?? "Sunny")
                
                Spacer()
                
                HStack(spacing: 8){
                    Text("H:\(appSettings.setTemperature(temp: highTempF ?? 0))")
                    Text("L:\(appSettings.setTemperature(temp: lowTempF ?? 0))")
                }
                .padding(.trailing, 2)
            }
            .font(.subheadline)
        }
        .padding(12)
        .frame(height: 110)
        .background(backgroundGradient, in: RoundedRectangle(cornerRadius: 14))
        .cornerRadius(14)
    }
    
    static func makeGradient(hour: String) -> LinearGradient {
        let morning = LinearGradient(
            colors: [
                Color(red: 0.45, green: 0.75, blue: 1.0),
                Color(red: 0.75, green: 0.9, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        let afternoon = LinearGradient(
            colors: [
                Color(red: 0.10, green: 0.50, blue: 0.95),
                Color(red: 1.00, green: 0.65, blue: 0.35)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        let night = LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.08, blue: 0.18),
                Color(red: 0.12, green: 0.15, blue: 0.30)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        let parts = hour.split(separator: " ")
        let hourPart = parts.count > 1 ? parts[1] : "00:00"
        let militarHour = Int(hourPart.split(separator: ":").first ?? "") ?? 0
        
        switch militarHour {
        case 6..<12: return morning
        case 12..<18: return afternoon
        default: return night
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    Group{
        SearchRowView(weather: WeatherResponse.mock)
            .padding(.horizontal)
        SearchRowView(weather: WeatherResponse.mocks[2])
            .padding(.horizontal)
    }
    .environment(appSettings)
}
