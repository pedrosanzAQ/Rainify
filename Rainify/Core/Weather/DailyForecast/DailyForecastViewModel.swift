//
//  DailyForecastViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

class DailyForecastViewModel {
    private(set) var Forecastdays: [Forecastday] = []
    
    init(forecastday: [Forecastday]){
        self.Forecastdays = forecastday
    }
    
    var hasData: Bool {
        return !Forecastdays.isEmpty
    }
}
