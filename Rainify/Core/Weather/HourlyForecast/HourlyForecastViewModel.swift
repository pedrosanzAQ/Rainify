//
//  HourlyForecastViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//
import SwiftUI

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
}
