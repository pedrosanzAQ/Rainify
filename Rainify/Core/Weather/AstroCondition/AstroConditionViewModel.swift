//
//  AstroConditionViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//

@MainActor
class AstroConditionViewModel {
    private var forecastdays: [Forecastday] = []
    
    init(forecastdays: [Forecastday]) {
        self.forecastdays = forecastdays
    }
    
    var hasData: Bool {
        return !forecastdays.isEmpty
    }
    
    var moonPhase: String? {
        return forecastdays.first?.astro.moonPhase
    }
    
    var nextMoonPhase: String? {
        forecastdays.indices.contains(1) ? forecastdays[1].astro.moonPhase : nil
    }
    
    var moonsetTime: String? {
        forecastdays.indices.contains(3) ? forecastdays[3].astro.moonset : nil
    }
    
    var moonIlumination: Int? {
        return forecastdays.first?.astro.moonIllumination
    }
}
