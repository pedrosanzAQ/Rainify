//
//  UVBarDraw.swift
//  Rainify
//
//  Created by pedrosanz on 30/05/25.
//

import SwiftUI

struct UVConditionView: View {
    var viewmodel: UVConditionViewModel
    
    var body: some View {
            ContentBoxView(title: "UV ") {
                    VStack(alignment: .leading){
                        
                        if viewmodel.hasData {
                            HStack(spacing: 6){
                                Text(viewmodel.uivTitle)
                                
                                Text(String(format: "%.1f", viewmodel.UVIndex))
                            }
                            .font(.headline)
                        }
                        
                        AirConditionBarDraw(
                            barWidth: viewmodel.barWidth,
                            minRange: Double(viewmodel.minRange),
                            maxRange: Double(viewmodel.maxRange),
                            value: viewmodel.UVIndex,
                            colorBar: [.green, .yellow, .orange, .red, .purple],
                            showNumbers: false)
                        .padding(.top, 2)
                        
        //                // Divider sticks
                        ZStack(alignment: .leading) {
                            ForEach(viewmodel.minRange...viewmodel.maxRange, id: \.self) { i in
                                VStack(spacing: 8) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 1, height: 20)
                                
                                Text("\(i)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                                .position(x: viewmodel.positionForIndex(i), y: -10)
                            }
                        }
                        .frame(width: viewmodel.barWidth - 32, height: 14)
                        
                        Divider()
                            .background(Color.primary.opacity(0.3))
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        
                        if viewmodel.hasData {
                            Text(viewmodel.uivDescription)
                                .font(.subheadline)
                        } else {
                            WithoutConnectionView()
                                .frame(maxWidth: .infinity)
                        }
                    }
            }
        }
}

#Preview("Data"){
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let current = weather.current
        UVConditionView(viewmodel: UVConditionViewModel(weather: current))
            .padding(.horizontal)
    }
}

#Preview("NoData") {
    UVConditionView(viewmodel: UVConditionViewModel(weather: nil))
        .padding(.horizontal)
}
