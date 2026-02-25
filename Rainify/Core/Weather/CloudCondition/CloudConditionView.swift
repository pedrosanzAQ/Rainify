//
//  CloudConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 30/05/25.
//

import SwiftUI

struct CloudConditionView: View {
    var viewmodel: CloudConditionViewModel
    
    var body: some View {
        ContentBoxView(title: "Cloud") {
            if viewmodel.hasData {
                VStack(alignment: .leading, spacing: 20){
                    Text("\(viewmodel.cloudPorcentaje ?? 0)%")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.theme.primary)
                    
                    Text(viewmodel.cloudyDescription())
                        .font(.subheadline)
                        .foregroundColor(.theme.primary)
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
        let currentWeather = weather.current
        CloudConditionView(viewmodel: CloudConditionViewModel(current: currentWeather))
            .frame(width: 180, height: 180)

    }
}

#Preview("NoData") {
    CloudConditionView(viewmodel: CloudConditionViewModel(current: nil))
        .frame(width: 180, height: 180)

}
