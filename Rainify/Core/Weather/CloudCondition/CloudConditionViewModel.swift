//
//  CloudConditionViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

class CloudConditionViewModel {
    private var currentWeather: Current?
    private var lastCloudPorcentaje: Int = 0
    
    init(current: Current?) {
        self.currentWeather = current
    }
    
    var hasData: Bool {
        return currentWeather != nil
    }
    
    var cloudPorcentaje: Int? {
        return currentWeather?.cloud
    }
    
    func cloudyDescription() -> String {
        guard let cloudPorcentaje else { return "No cloud cover 🌤️" }
        
        if cloudPorcentaje > lastCloudPorcentaje {
            return "Cloudier than yesterday, skies might look gray ☁️"
        } else if cloudPorcentaje < lastCloudPorcentaje {
            return "Clearer skies than yesterday, enjoy the sun 🌤️"
        } else {
            return "Similar cloud cover to yesterday 🌥️"
        }
    }
}

