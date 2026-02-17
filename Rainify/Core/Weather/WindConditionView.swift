//
//  WindConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 20/05/25.
//

import SwiftUI

// 17181C

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
// E5C17C

struct WindConditionView: View {
    var viewmodel: WindConditionViewModel
    
    var body: some View {
        ContentBoxView(title: "Wind") {
            VStack(spacing: 8){
                CompassDraw(direction: viewmodel.windDegress ?? 0)
//                    .background(Color.green)
                    .frame(width: 165)
                
                if viewmodel.current != nil {
                    VStack(spacing: 10){
                        HStack {
                            Text("Wind")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(viewmodel.windSpeed ?? "--.--")
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text("Gusts")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(viewmodel.gusts ?? "--.--")
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text("Direction")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(viewmodel.windDegress ?? 0)")
                                .font(.subheadline)
                        }
                    }
                    .padding(.top)
                } else {
                    WithoutConnectionView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxHeight: .infinity)
//            .padding(4)
        }
    }
}

#Preview("Data") {
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let current = weather.current
        WindConditionView(viewmodel: WindConditionViewModel(current: current))
            .frame(width: 100, height: 350)
    }
}

#Preview("NoData") {
    WindConditionView(viewmodel: WindConditionViewModel(current: nil))
    .frame(width: 200, height: 350)

}


// AMARILLO - DORADO:   D6B86F
// Rosa:                E6A6C7
// DFA1BE

