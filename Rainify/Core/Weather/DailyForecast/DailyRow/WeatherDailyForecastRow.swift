//
//  WeatherDailyForecastRow.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//
import SwiftUI

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
