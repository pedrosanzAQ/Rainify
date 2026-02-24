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
    private(set) var temperatureUnit: TemperatureUnit {
        didSet {
            UserDefaults.temperatureUnit = temperatureUnit
        }
    }
    
    init(temperatureUnit: TemperatureUnit = UserDefaults.temperatureUnit){
        self.temperatureUnit = temperatureUnit
    }
    
    func temperatureToggle() {
        temperatureUnit = temperatureUnit == .celcius ? .fahrenheit : .celcius
    }
    
    func setTemperature(temp: Double) -> String {
        // by defect temp is Fahrenheit
        let roundedTemp = temp.rounded()
        
        if temperatureUnit == .fahrenheit {
            return "\(Int(roundedTemp))°F"
        } else {
            let tempC = (temp - 32) * 5/9
            return "\( Int((tempC.rounded())))°C"
        }
    }
    
    func setIntTemperature(temp: Double) -> Int {
        // by defect temp is Fahrenheit
        let roundedTemp = temp.rounded()
        
        if temperatureUnit == .fahrenheit {
            return Int(roundedTemp)
        } else {
            let tempC = (temp - 32) * 5/9
            return Int((tempC.rounded()))
        }
    }
}
