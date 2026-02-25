//
//  WindConditionViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

class WindConditionViewModel {
    var current: Current?
    private var isEn: Bool?
    
    init(current: Current?) {
        self.current = current
    }
    
    var windSpeed: String? {
        guard let current else { return nil }
        return (isEn ?? true)
        ? String(format: "%.2f Mi/h", current.windMph)
        : String(format: "%.2f Km/h", current.windKph)
    }
    
    var gusts: String? {
        guard let current else { return nil}
        return (isEn ?? true)
        ? String(format: "%.2f Mi/h", current.gustMph)
        : String(format: "%.2f Km/h", current.gustKph)
    }
    
    var windDirection: String? {
        let dir = current?.windDir
        if isEn ?? true { return dir }
        
        return dir?
            .replacingOccurrences(of: "W", with: "O")
            .replacingOccurrences(of: "w", with: "o")
    }
    
    var windDegress: Int? {
        return current?.windDegree
    }
}
