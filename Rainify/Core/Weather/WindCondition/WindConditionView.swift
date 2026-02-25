//
//  WindConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 20/05/25.
//

import SwiftUI

struct WindConditionView: View {
    var viewmodel: WindConditionViewModel
    
    var body: some View {
        ContentBoxView(title: "Wind") {
            VStack(spacing: 8){
                CompassDraw(direction: viewmodel.windDegress ?? 0)
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
