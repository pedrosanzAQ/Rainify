//
//  PressureGaugeViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

class PressureGaugeViewModel {
    private var weather: Current?
    
    init(weather: Current?) {
        self.weather = weather
    }
    
    let startAngle: Double = -135
    let endAngle: Double = 135
    let tickCount: Int = 22
    let radius: CGFloat = 55
    
    // In
    let minPressure: Double = 25.70
    let maxPressure: Double = 32.03
    
    var hasData: Bool {
        return weather != nil
    }
    
    var pressure: Double? {
        return weather?.pressureIn.rounded()
    }
    
    func getAnglePressure() -> Double {
        let minAngle: Double = -45
        let maxAngle: Double = 225
        
        guard let pressure else { return 0 }
        
        let progress = (pressure - minPressure) / (maxPressure - minPressure)
        
        let anglePressure = minAngle + progress * (maxAngle - (minAngle))
        
        return anglePressure
    }
    
    func getOffset(for angle: Double, distance: CGFloat) -> CGSize {
        let radians = angle * .pi / 180
        let dx = cos(radians) * distance
        let dy = sin(radians) * distance
        return CGSize(width: dx, height: dy)
    }
}
