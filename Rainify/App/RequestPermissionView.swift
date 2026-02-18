//
//  Testing.swift
//  Rainify
//
//  Created by pedrosanz on 30/01/26.
//

import SwiftUI
import CoreLocation

struct RequestPermissionView: View {
    let state: CLAuthorizationStatus
    let requestPermission: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                HStack(spacing: 20) {
                    Image(systemName: state == .denied
                          ? "location.slash"
                          : "location.fill")
                    .font(.system(size: 40))
                    .padding(.trailing, 2)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Ubicación necesaria")
                            .font(.title3)
                            .bold()
                        
                        Text(message)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal)
                
                Button(buttonTitle) {
                    action()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.blue)
                .foregroundColor(.primary)
                .font(.headline)
                .clipShape(Capsule())
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: state)
    }
    
    private var message: String {
        switch state {
        case .denied, .restricted:
            "Enable location in Settings to use the app."
        default:
            "Allow your location to display the local weather."
        }
    }
    
    private var buttonTitle: String {
        switch state {
        case .denied, .restricted:
            "Open Settings"
        default:
            "Allow Location"
        }
    }
    
    private func action() {
        switch state {
        case .denied, .restricted:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        default:
            requestPermission()
        }
    }
    
}

#Preview {
    RequestPermissionView(state: .authorizedWhenInUse, requestPermission: {
        print("Mock: allow permission")
    })
}
