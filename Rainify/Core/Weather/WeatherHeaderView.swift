//
//  WeatherHeaderView.swift
//  Rainify
//
//  Created by pedrosanz on 20/06/25.
//

import SwiftUI
import SpriteKit

struct WeatherHeaderView: View {
    @Environment(AppSettings.self) private var appSettings
    let progress: Double
    var viewmodel: WeatherInformationViewModel
    @State private var animateIn: Bool = false
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing: 4){
                Text("\(viewmodel.location ?? "Location")")
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("Humidity: \(viewmodel.humidity ?? 0)%")
                    
                    Text("|")
                        .padding(.horizontal, 3)
                    
                    Text("\(appSettings.setTemperature(temp: viewmodel.temperatureF ?? 0))")
                    
                    Text("|")
                        .padding(.horizontal, 3)
                    
                    Text("Feels like: \(appSettings.setTemperature(temp: viewmodel.feelsLikeF ?? 0))")
                }
                .font(.callout)
                .fontWeight(.semibold)
            }
            .padding(.bottom, 4)
            .offset(y: animateIn ? 0 : -20)
            .opacity(animateIn ? 1 : 0)
        }
        .frame(height: 70)
        .frame(maxWidth: .infinity)
        .shadow(radius: 0.5)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                withAnimation(.spring) {
                    animateIn = true
                }
            }
        }
    }
}

struct FadeOverlayView: View {
    @Environment(\.colorScheme) var colorScheme
    let progress: Double
    let scene: CloudScene7

    var body: some View {
        ZStack {
            Image("rainyWeather")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 130)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            TransparentCloudsView(
                height: 130,
                background: .clear,
                scene: scene
            )
            .frame(height: 130)
            .clipped()
        }
        .opacity(progress)
    }
    
    var gradientColors: [Color] {
        if colorScheme == .dark {
            return [
                Color.black.opacity(0.4),
                Color.black.opacity(0.6),
                Color.black.opacity(0.8),
            ]
        } else {
            return [
                Color.white.opacity(0.2),
                Color.white.opacity(0.4),
                Color.white.opacity(0.6),
                Color.white.opacity(0.8),
                Color.white.opacity(0.9),
            ]
        }
    }

}

#Preview {
    let appSettings = AppSettings()
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        WeatherHeaderView(
            progress: 1,
            viewmodel: WeatherInformationViewModel(weatherResponse: weatherResponse)
        )
        .environment(appSettings)
    }
}
