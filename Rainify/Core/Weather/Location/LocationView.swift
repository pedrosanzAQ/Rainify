//
//  LocationView.swift
//  Rainify
//
//  Created by pedrosanz on 18/03/25.
//
import SwiftUI

// keywords C679DD
struct LocationView: View {
    @Environment(\.safeAreaInsets) var safeArea
    @Environment(AppSettings.self) private var appSettings
    let width = UIScreen.main.bounds.width
    @State var clouds: CloudScenes?
    @State var scrollOffset: CGFloat = 0
    
    @State var viewmodel: LocationViewModel
    var isSheetPresented: Bool? = false

    var body: some View {
        ZStack(alignment: .top){
            
            if let clouds {
                WeatherBackground(scene: clouds.bigScene)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .frame(height: 550)
            }
            
            ScrollView {
                VStack(spacing: 0){
                    Color.clear
                        .frame(height: 0)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { oldVaue, newValue in
                                        scrollOffset = newValue
                                    }
                            }
                        )
                    
                    ZStack(alignment: .top){
                        if !(isSheetPresented ?? false) {
                            Button {
                                viewmodel.toggleFavorite()
    
                                print(viewmodel.isPinned)
                            } label: {
                                Image(systemName: viewmodel.isPinned ? "star.fill" : "star")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 45, height: 45)
                                    .background(Color.secondary.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(.trailing, 30)
                            .padding(.top, 30)
                            
                        }

                        
                        LazyVStack(spacing: 20){                            
                            WeatherInformationView(viewmodel: WeatherInformationViewModel(weatherResponse: viewmodel.weather))//140
                                .padding(.top, 80)
                            
                            HourlyForecastView(viewModel: HourlyForecastViewModel(forecast:viewmodel.forecastday ?? []))
                                .padding(.top)
                            
                            DailyForecastView(viewmodel: DailyForecastViewModel(forecastday: viewmodel.forecastday ?? []))
                            
                            AirConditionBarView(viewmodel: AirConditionViewModel(weather: viewmodel.current))
                            
                            HStack(spacing: 16){
                                CloudConditionView(viewmodel: CloudConditionViewModel(current: viewmodel.current))
                                ChanceRainView(viewmodel: ChanceRainViewModel(forecastday: viewmodel.forecastday ?? []))
                                
                            }
                            .frame(height: 180)
                            
                            UVConditionView(viewmodel: UVConditionViewModel(weather: viewmodel.current))
                            
                            HStack(spacing: 16){
                                WindConditionView(viewmodel: WindConditionViewModel(current: viewmodel.current))
                                    .frame(height: 340)
                                
                                VStack(spacing: 16){
                                    VisibilityView(viewmodel: VisibilityViewModel(current: viewmodel.current))
                                    PressureGaugeView(viewmodel: PressureGaugeViewModel(weather: viewmodel.current))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            AstroConditionView(viewmodel: AstroConditionViewModel(forecastdays: viewmodel.forecastday ?? []))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
                
            }
            .scrollIndicators(.hidden)
            .padding(.top, safeArea.top)
            .padding(.top, 2)
            
            if let clouds, isSheetPresented == false {
                if !(isSheetPresented ?? false) {
                    FadeOverlayView(progress: fadeProgress, scene: clouds.smallScene)
                        .frame(height: 130)
                        .allowsHitTesting(false)
                        .ignoresSafeArea(edges: .top)
                        .zIndex(3)
                    
                    if headerProgress > 0.99 {
                        WeatherHeaderView(
                            progress: headerProgress,
                            viewmodel: WeatherInformationViewModel(weatherResponse: viewmodel.weather)
                        )
                        .opacity(headerProgress)
                        .padding(.top, safeArea.top)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.4), value: headerProgress)
                        .zIndex(3)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .task {
            self.clouds = CloudScenes()
        }
    }

        private var fadeProgress: Double {
            let start: CGFloat = 0
            let end: CGFloat = (-82 + safeArea.top)
            let raw = (scrollOffset - start) / (end - start)
            return max(0, min(1, Double(raw)))
        }

        private var headerProgress: Double {
            let start: CGFloat = 0
            let end: CGFloat = (-82 + safeArea.top)
            let raw = (scrollOffset - start) / (end - start)
            return max(0, min(1, Double(raw)))
        }

}

#Preview ("Data"){
    let appSettings = AppSettings()
    if let weatherResponse = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
            LocationView(viewmodel: LocationViewModel(location: StoredLocation.mock, weather: weatherResponse, container: DevPreview.shared.container), isSheetPresented: false)
            .environment(appSettings)
    }
}

#Preview("NoData") {
    let appSettings = AppSettings()
    LocationView(viewmodel: LocationViewModel(location: StoredLocation.mock, weather: nil, container: DevPreview.shared.container))
        .environment(appSettings)

}
