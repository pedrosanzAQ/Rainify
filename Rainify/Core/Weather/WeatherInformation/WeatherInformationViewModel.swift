//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

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
    
    var temperatureF: Double? {
        guard let temp = weatherResponse?.current.tempF else { return nil }
        return temp
    }
    
    var humidity: Int? {
        return weatherResponse?.current.humidity
    }
    
    var feelsLikeF: Double? {
        guard let feelsLike = weatherResponse?.current.feelslikeF else { return nil}
        return feelsLike
    }
    
    var lowTemperatureF: Double?{
        guard let minTemp = weatherResponse?.forecast.forecastday.first?.day.mintempF else { return nil}
        return minTemp
    }
    
    var highTemperatureF: Double? {
        guard let maxTemp = weatherResponse?.forecast.forecastday.first?.day.maxtempF else { return nil}
        return maxTemp
    }
}
