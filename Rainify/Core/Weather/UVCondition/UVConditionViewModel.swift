//
//  UVConditionViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//
import SwiftUI

@MainActor
class UVConditionViewModel {
    private var currentWeather: Current?
    let minRange = 0
    let maxRange = 11
    var barWidth: CGFloat = UIScreen.main.bounds.width - 32
    
    init(weather: Current?){
        self.currentWeather = weather
    }
    
    var hasData: Bool {
        return currentWeather != nil
    }
    
    var UVIndex: Double { currentWeather?.uv ?? -1 }
    
    var uivTitle: String {
        switch UVIndex {
        case 0...2:
            return "Low"
        case 3...5:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11:
            return "Extreme"
        default:
            return "Unknown"
        }
    }
    
    var uivDescription: String {
        switch UVIndex {
        case 0...2:
            return "No protection needed. Low levels of ultraviolet radiation are present in the atmosphere."
        case 3...5:
            return "Moderate levels of ultraviolet radiation are present in the atmosphere."
        case 6...7:
            return "High levels of ultraviolet radiation are present in the atmosphere."
        case 8...10:
            return ""
        case 11:
            return ""
        default:
            return "noDescription"
        }
    }
    
    func positionForIndex(_ index: Int) -> CGFloat {
        let usableWidth = barWidth - 32
        let sectionCount = CGFloat(maxRange - minRange)
        return CGFloat(index - minRange) / sectionCount * usableWidth
    }
}
