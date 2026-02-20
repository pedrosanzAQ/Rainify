//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 20/02/26.
//
import SwiftUI

enum TemperatureUnit: String {
    case celcius
    case fahrenheit
}

@Observable
class AppSettings {
    var unit: TemperatureUnit = .fahrenheit
    
    func temperatureToggle() {
        unit = unit == .celcius ? .fahrenheit : .celcius
    }
    
    func setTemperature(temp: Double) -> String {
        // by defect temp is Fahrenheit
        let roundedTemp = temp.rounded()
        
        if unit == .fahrenheit {
            return "\(Int(roundedTemp))°F"
        } else {
            let tempC = (temp - 32) * 5/9
            return "\( Int((tempC.rounded())))°C"
        }
    }
    
    func setIntTemperature(temp: Double) -> Int {
        // by defect temp is Fahrenheit
        let roundedTemp = temp.rounded()
        
        if unit == .fahrenheit {
            return Int(roundedTemp)
        } else {
            let tempC = (temp - 32) * 5/9
            return Int((tempC.rounded()))
        }
    }
}
