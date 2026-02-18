//
//  WelcomeView.swift
//  Rainify
//
//  Created by pedrosanz on 15/03/25.
//

import SwiftUI
import CoreLocation

struct WelcomeView: View {
    @State var viewmodel: WelcomeViewModel
    
    private let width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            imageLogo
            
            tittleSection
                .padding(.bottom, 6)
            
            Button(action: {
                viewmodel.onGetStartedPressed()
            }, label: {
                Text("Get started")
                    .frame(maxWidth: width * 0.8)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
            })
            .contentShape(Rectangle())
            
            policySection
                .padding(.top, 8)
        }
        .sheet(isPresented: $viewmodel.showPopup) {
            Testing(state: viewmodel.authorizationStatus, requestPermission: {
                viewmodel.requestLocationPermission()
            })
            .presentationDetents([.fraction(0.25)])
        }
        .onChange(of: viewmodel.authorizationStatus) {
            Task {
               await viewmodel.onAuthorizationChanged()
            }
        }
    }
}

private var tittleSection: some View {
    VStack(spacing: 4){
        Text("Rainify")
            .font(.largeTitle)
            .fontWeight(.semibold)
        Text("Weather, clear and precise 🌦️")
            .font(.subheadline)
            .foregroundStyle(Color(.systemGray))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 36)
    }

}

private var imageLogo: some View {
    Image("rainify-weather2")
        .resizable()
        .scaledToFill()
        .clipped()
        .ignoresSafeArea()
}

private var policySection: some View {
    VStack(){
        HStack{
            Text("Terms of service")
            Circle()
                .frame(width: 4, height: 4)
            Text("Privacy policy")
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }

}

@Observable
@MainActor
class WelcomeViewModel {
    // observables
    let realtimeManager: RealTimeManager
    let locationManager: LocationsPersistenceManager
    let weatherManager: WeatherManager
    
    var showPopup: Bool = false
    private let onFinished: () -> Void
    
    
    init(container: DependencyContainer, onFinished: @escaping () -> Void) {
        self.realtimeManager = container.resolve(RealTimeManager.self)!
        self.locationManager = container.resolve(LocationsPersistenceManager.self)!
        self.weatherManager = container.resolve(WeatherManager.self)!
        self.onFinished = onFinished
    }
    
    var authorizationStatus: CLAuthorizationStatus{
        realtimeManager.authorizationStatus
    }
    
    func onGetStartedPressed() {
        showPopup = true
    }
    
    func requestLocationPermission() {
        realtimeManager.requestPermission()
    }
    
    func onAuthorizationChanged() async {
        let status = realtimeManager.authorizationStatus
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        
        showPopup = false
        await saveCurrentLocation()
        print("saveCurrentLocation")
        onFinished()
    }
    
    private func saveCurrentLocation() async {
        print("entre a la funcion")
        guard let response = realtimeManager.currentLocation else { return }
        print("tengo el response")
        guard let location = try? await weatherManager.getCurrentLocation(lat: response.coordinate.latitude, lon: response.coordinate.longitude) else { return }
        print("tengo la localizacion")
        locationManager.addFavorites(location: location)
        print("guarde en favs")
        await weatherManager.loadWeather(locationId: location.id, lat: location.lat, lon: location.long)
    }
}

#Preview {
    GeometryReader { geo in 
        WelcomeView(viewmodel: WelcomeViewModel(container: DevPreview.shared.container) {
            
        })
    }
}

