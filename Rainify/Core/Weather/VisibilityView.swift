//
//  VisibilityConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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

struct VisibilityView: View {
    var viewmodel: VisibilityViewModel
    
    var body: some View {
        ContentBoxView(title: "Visibility") {
            if viewmodel.hasData {
                VStack(alignment: .leading, spacing: 20){
                    Text(viewmodel.visibility ?? "0.0")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text(viewmodel.visibilityDescription)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                WithoutConnectionView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview("Data"){
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let current = weather.current
        VisibilityView(viewmodel: VisibilityViewModel(current: current))
            .frame( width: 180, height: 180)
    }
}

#Preview("NoData"){
    VisibilityView(viewmodel: VisibilityViewModel(current: nil))
        .frame( width: 180, height: 180)
}
