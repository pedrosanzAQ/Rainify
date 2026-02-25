//
//  UserDefaults.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import Foundation

extension UserDefaults {
    private struct Keys {
        static let showTabbarView = "showTabbarView"
        static let temperatureUnit = "temperatureUnit"
    }
    
    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        }
        set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
    
    static var temperatureUnit: TemperatureUnit {
        get {
            guard let rawValue = standard.string(forKey: Keys.temperatureUnit),
                  let unit = TemperatureUnit(rawValue: rawValue) else {
                return TemperatureUnit.fahrenheit
            }
            return unit
        }
        set {
            standard.set(newValue.rawValue, forKey: Keys.temperatureUnit)
        }
    }
}
