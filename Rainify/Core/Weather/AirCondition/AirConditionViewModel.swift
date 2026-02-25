//
//  AirConditionViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//
import SwiftUI

@Observable
@MainActor
class AirConditionViewModel {
    var weather: Current?
    
    init(weather: Current?) {
        self.weather = weather
    }
    
    var defraIndex: Double {
        if let index = weather?.airQuality?["gb-defra-index"] {
            return index
        }
        return 0
    }
    
    var airQualityTitle: String {
        switch defraIndex {
        case 0.1...3:
            return "Acceptable"
        case 4...6:
            return "Moderate"
        case 7...9:
            return "Poor"
        case 10:
            return "Very Poor"
        default:
            return "Unknowm"
        }
    }
    
    var airQualityDescription: String {
        switch defraIndex {
        case 0.1...3:
            return "Air quality is good and poses little or no risk."
        case 4...6:
            return "Air quality is acceptable, but sensitive individuals may feel slight effects."
        case 7...9:
            return "Air quality is poor and may cause health effects, especially for sensitive groups."
        case 10:
            return "Air quality is very poor and may affect everyone’s health."
        default:
            return "Air quality information is unavailable."
        }
    }
}
