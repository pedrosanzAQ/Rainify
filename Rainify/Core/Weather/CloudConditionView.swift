//
//  CloudConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 30/05/25.
//

import SwiftUI

class CloudConditionViewModel {
    private var currentWeather: Current?
    private var lastCloudPorcentaje: Int = 0
    
    init(current: Current?) {
        self.currentWeather = current
    }
    
    var hasData: Bool {
        return currentWeather != nil
    }
    
    var cloudPorcentaje: Int? {
        return currentWeather?.cloud
    }
    
    // i need the pastDailyChanceOfRain, so i need to save this forecastday
    // must be other manager
    func cloudyDescription() -> String {
        guard let cloudPorcentaje else { return "No cloud cover 🌤️" }
        
        if cloudPorcentaje > lastCloudPorcentaje {
            return "Cloudier than yesterday, skies might look gray ☁️"
        } else if cloudPorcentaje < lastCloudPorcentaje {
            return "Clearer skies than yesterday, enjoy the sun 🌤️"
        } else {
            return "Similar cloud cover to yesterday 🌥️"
        }
    }
}

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
