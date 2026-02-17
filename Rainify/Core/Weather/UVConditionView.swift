//
//  UVBarDraw.swift
//  Rainify
//
//  Created by pedrosanz on 30/05/25.
//

import SwiftUI

@MainActor
class UVConditionVieModel {
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

struct UVConditionView: View {
    var viewmodel: UVConditionVieModel
    
    var body: some View {
            ContentBoxView(title: "UV ") {
//                if viewmodel.hasData {
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
                        
        //                // Palitos divisores
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
        UVConditionView(viewmodel: UVConditionVieModel(weather: current))
            .padding(.horizontal)
    }
}

#Preview("NoData") {
    UVConditionView(viewmodel: UVConditionVieModel(weather: nil))
        .padding(.horizontal)
}
