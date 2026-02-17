//
//  AirConditionBarView.swift
//  Rainify
//
//  Created by pedrosanz on 28/05/25.
//

import SwiftUI

@Observable
@MainActor
class AirConditionViewModel {
    var weather: Current?
    
    init(weather: Current?) {
        self.weather = weather
    }
        
    var defraIndex: Double {
        if let index = weather?.airQuality?["gb-defra-index"] {
            return index
        }
        return 0
    }
    
    var airQualityTitle: String {
        switch defraIndex {
        case 0.1...3:
            return "Acceptable"
        case 4...6:
            return "Moderate"
        case 7...9:
            return "Poor"
        case 10:
            return "Very Poor"
        default:
            return "Unknowm"
        }
    }
    
    var airQualityDescription: String {
        switch defraIndex {
        case 0.1...3:
            return "Air quality is good and poses little or no risk."
        case 4...6:
            return "Air quality is acceptable, but sensitive individuals may feel slight effects."
        case 7...9:
            return "Air quality is poor and may cause health effects, especially for sensitive groups."
        case 10:
            return "Air quality is very poor and may affect everyone’s health."
        default:
            return "Air quality information is unavailable."
        }
    }
}

struct AirConditionBarView: View {
    @StateObject private var deviceInfo = DeviceInfo()
    @State var viewmodel: AirConditionViewModel
    // get width in pt
    // padding works and applied in pt (default 16)
    @State private var value: Double = 0
    var widthWithPadding: CGFloat = UIScreen.main.bounds.width - 32 // (width in pt)
    
    
    var body: some View {
        ContentBoxView(title: "Air Condition") {
            VStack(alignment: .leading){
                if viewmodel.defraIndex != 0 {
                    HStack(spacing: 4){
                        Text("\(Int(viewmodel.defraIndex))")
                        
                        Text(viewmodel.airQualityTitle)
                    }
                    .foregroundColor(.theme.dinamicText)
                    .font(.headline)
                    .padding(.leading, 2)
                }

                AirConditionBarDraw(
                    barWidth: widthWithPadding,
                    minRange: 0, maxRange: 10,
                    value: viewmodel.defraIndex,
                    colorBar: [.green, .yellow, .orange, .red])
                
                Divider()
                    .background(Color.primary.opacity(0.3))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)
                
                
                if viewmodel.weather != nil {
                    HStack {
                        Text(viewmodel.airQualityDescription)
                    }
                } else {
                    WithoutConnectionView()
                        .padding(.horizontal)
                }
            }
        }
//        .padding(.horizontal)
//        .background(Color.pink)
    }
    
}

#Preview("Data") {
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let weather = weatherResponse.current
        AirConditionBarView(viewmodel: AirConditionViewModel(weather: weather))
            .padding(.horizontal)
//            .background(Color.green)
    }
}

#Preview("No data") {
    AirConditionBarView(viewmodel: AirConditionViewModel(weather: nil))
        .padding(.horizontal)
}
