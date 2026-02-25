//
//  VisibilityConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

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
