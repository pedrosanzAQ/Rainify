//
//  WeatherInfomatinView.swift
//  Rainify
//
//  Created by pedrosanz on 07/12/25.
//

import SwiftUI

struct WeatherInformationView: View {
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
                        HStack(spacing: 2) {
                            Text(viewmodel.temperatureC ?? "0")
                            
                            Text("°C")
                        }
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
                            
                            HStack(spacing: 2){
                                Text(viewmodel.lowTemperatureC ?? "0°C")
                                
                                Text("°C")
                            }
                        }
                        
                        HStack(spacing: 4){
                            Image(systemName: "thermometer.high")
                            
                            HStack(spacing: 2){
                                Text(viewmodel.highTemperatureC ?? "0°C")
                                
                                Text("°C")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, -4)
                //            .frame(width: width * 0.6)
                
                
                VStack(spacing: 4) {
                    Text("Feels like")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Image(systemName: "thermometer.variable.and.figure")
                        .fontWeight(.semibold)
//                    Text("28°C")
                    if viewmodel.hasData {
                        HStack(spacing: 2){
                            Text(viewmodel.feelsLikeC ?? "0")
                            
                            Text("°C")
                        }
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

class WeatherInformationViewModel {
    private(set) var weatherResponse: WeatherResponse?
    
    init(weatherResponse: WeatherResponse?) {
        self.weatherResponse = weatherResponse
    }
    
    var hasData: Bool{
        return weatherResponse != nil
    }
    
    var location: String? {
        return weatherResponse?.location.name
    }
    
    var condition: String? {
        return weatherResponse?.current.condition.text
    }
    
    var temperatureC: String? {
        guard let temp = weatherResponse?.current.tempC else { return nil }
        return String(Int(temp.rounded()))
    }
    
    var humidity: Int? {
        return weatherResponse?.current.humidity
    }
    
    var feelsLikeC: String? {
        guard let feelsLike = weatherResponse?.current.feelslikeC else { return nil}
        return String(Int(feelsLike.rounded()))
    }
    
    var lowTemperatureC: String?{
        guard let minTemp = weatherResponse?.forecast.forecastday.first?.day.mintempC else { return nil}
        return String(Int(minTemp.rounded()))
    }
    
    var highTemperatureC: String? {
        guard let maxTemp = weatherResponse?.forecast.forecastday.first?.day.maxtempC else { return nil}
        return String(Int(maxTemp.rounded()))
    }
}

#Preview("Data"){
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        WeatherInformationView(viewmodel: WeatherInformationViewModel(weatherResponse: weatherResponse))
            .background(Color.blue.opacity(0.5))
            .padding(.horizontal)
    }
}

#Preview("NoData"){
//    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
    WeatherInformationView(viewmodel: WeatherInformationViewModel(weatherResponse: nil))
            .background(Color.blue.opacity(0.5))
//    }
}
