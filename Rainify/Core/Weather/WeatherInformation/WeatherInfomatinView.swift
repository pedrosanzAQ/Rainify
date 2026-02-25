//
//  WeatherInfomatinView.swift
//  Rainify
//
//  Created by pedrosanz on 07/12/25.
//
import SwiftUI

struct WeatherInformationView: View {
    @Environment(AppSettings.self) private var appSettings
    let width = UIScreen.main.bounds.width
    var viewmodel: WeatherInformationViewModel
    
    var body: some View {
        VStack(spacing: 8){
            Text(viewmodel.location ?? "Location")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.top, 4)
            
            HStack(alignment: .top, spacing: 8){
                VStack(spacing: 4){
                    Text("Humidity")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Image(systemName: "humidity")
                        .fontWeight(.semibold)
                    
                    if viewmodel.hasData {
                        HStack(spacing: 2){
                            Text("\(viewmodel.humidity ?? 0)")
                            
                            Text("%")
                        }
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: width * 0.2)
                .padding(.top, 2)
                
                VStack(spacing: 4) {
                    if viewmodel.hasData {
                        Text("\(appSettings.setTemperature(temp: viewmodel.temperatureF ?? 0))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                        Text(viewmodel.condition ?? "Sunny")
                            .font(.headline)
                            .padding(.bottom, 4)
                    }else {
                        ProgressView()
                            .padding(.vertical, 8)
                    }
                    
                    HStack(spacing: 16){
                        HStack(spacing: 4){
                            Image(systemName: "thermometer.low")
                            
                            Text("\(appSettings.setTemperature(temp: viewmodel.lowTemperatureF ?? 0))")
                                
                        }
                        
                        HStack(spacing: 4){
                            Image(systemName: "thermometer.high")
                            
                            Text("\(appSettings.setTemperature(temp: viewmodel.highTemperatureF ?? 0))")
                                
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, -4)
                
                
                VStack(spacing: 4) {
                    Text("Feels like")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Image(systemName: "thermometer.variable.and.figure")
                        .fontWeight(.semibold)
                    if viewmodel.hasData {
                    Text("\(appSettings.setTemperature(temp: viewmodel.feelsLikeF ?? 0))")
                            
                    } else {
                        ProgressView()
                    }
                    
                }
                .frame(width: width * 0.2)
                .padding(.top, 2)
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview("Data"){
    let appSettings = AppSettings()
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        WeatherInformationView(viewmodel: WeatherInformationViewModel(weatherResponse: weatherResponse))
            .padding(.horizontal)
            .environment(appSettings)
    }
}

#Preview("NoData"){
    let appSettings = AppSettings()
    WeatherInformationView(viewmodel: WeatherInformationViewModel(weatherResponse: nil))
        .environment(appSettings)
}
