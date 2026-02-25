//
//  AirConditionBarView.swift
//  Rainify
//
//  Created by pedrosanz on 28/05/25.
//

import SwiftUI

struct AirConditionBarView: View {
    @StateObject private var deviceInfo = DeviceInfo()
    @State var viewmodel: AirConditionViewModel
    // get width in pt
    // padding works and applied in pt (default 16)
    @State private var value: Double = 0
    var widthWithPadding: CGFloat = UIScreen.main.bounds.width - 32
    
    
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
    }
    
}

#Preview("Data") {
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let weather = weatherResponse.current
        AirConditionBarView(viewmodel: AirConditionViewModel(weather: weather))
            .padding(.horizontal)
    }
}

#Preview("No data") {
    AirConditionBarView(viewmodel: AirConditionViewModel(weather: nil))
        .padding(.horizontal)
}
