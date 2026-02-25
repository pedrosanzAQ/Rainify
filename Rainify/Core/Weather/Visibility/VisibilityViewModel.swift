//
//  VisibilityViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 24/02/26.
//

@MainActor
class VisibilityViewModel {
    private var current: Current?
    private var isEn: Bool?
    
    init(current: Current?) {
        self.current = current
    }
    
    var hasData: Bool {
        return current != nil
    }
    
    var visibility: String? {
        (isEn ?? true)
        ? String(format: "%.1f mi", current?.visMiles ?? 0)
        : String(format: "%.1f km", current?.visKM ?? 0)
    }
    
    var visibilityDescription: String {
        let miles: Double = {
            if isEn ?? true {
                return current?.visMiles ?? 0
            } else {
                return (current?.visKM ?? 0) / 1.60934
            }
        }()
        
        switch miles {
        case let x where x > 6:
            return "Excellent visibility — clear air and no obstructions."
        case 3...6:
            return "Good visibility — slight haze, mostly clear"
        case 1...3:
            return "Moderate visibility — some haze or light fog."
        case 0.6...1:
            return "Low visibility — dense fog, drive with caution."
        default:
            return "Very low visibility — hazardous conditions."
        }
    }
}
