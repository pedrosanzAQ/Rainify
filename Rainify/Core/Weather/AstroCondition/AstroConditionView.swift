//
//  AstroConditionView.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

struct AstroConditionView: View {
    var viewmodel: AstroConditionViewModel
    
    var body: some View {
        ContentBoxView(title: viewmodel.moonPhase ?? "Astro") {
            HStack(spacing: 16){
                
                if viewmodel.hasData {
                    VStack(alignment: . leading, spacing: 20) {
                        HStack{
                            Text("Moonset")
                                .foregroundColor(.theme.dinamicText)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(viewmodel.moonsetTime ?? "----")
                                .foregroundColor(.theme.dinamicText)
                                .font(.subheadline)
                        }
                        

                        HStack{
                            Text("Ilumination")
                                .foregroundColor(.theme.dinamicText)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(viewmodel.moonIlumination ?? 0)%")
                                .foregroundColor(.theme.dinamicText)
                        }
                        
                        HStack {
                            Text(viewmodel.nextMoonPhase ?? "----")
                                .foregroundColor(.theme.dinamicText)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("Tmrw")
                                .foregroundColor(.theme.dinamicText)
                        }
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    
                } else {
                    WithoutConnectionView()
                        .frame(maxWidth: .infinity)
                }
                
                MoonShape(phase: viewmodel.moonPhase ?? "Full moon")
                    .frame(width: 145, height: 145)
                
            }
            .padding(.horizontal, 4)
            .padding(.vertical, -4)
        }
    }
}

#Preview("Data") {
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let forecastdays = weather.forecast.forecastday
        AstroConditionView(viewmodel: AstroConditionViewModel(forecastdays: forecastdays))
            .padding(.horizontal)
    }
}

#Preview("NoData") {
    AstroConditionView(viewmodel: AstroConditionViewModel(forecastdays: []))
        .padding(.horizontal)
}
