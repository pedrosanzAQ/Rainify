//
//  SearchMenuActionView.swift
//  Rainify
//
//  Created by pedrosanz on 19/02/26.
//

import SwiftUI

struct SearchMenuActionView: View {
    @Environment(AppSettings.self) private var appSettings
    var onChangeUnit: () -> Void
    
    var body: some View {
        VStack(spacing: 16){
               
            VStack(){
                HStack {
                    Text("Edit list")
                    Spacer()
                    Image(systemName: "pencil")
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("Notifications")
                    Spacer()
                    Image(systemName: "bell.badge")
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            .background(.ultraThinMaterial)
            
            Button {
                withAnimation {
                    onChangeUnit()
                }
            } label: {
                HStack {
                    Text(appSettings.temperatureUnit.rawValue.capitalized)
                    Spacer()
                    Image(systemName: appSettings.temperatureUnit == .celcius ? "degreesign.celsius" : "degreesign.fahrenheit")
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .buttonStyle(.plain)
            .scaleEffect(1.0)
        }
        .frame(width: 220)
        .background(.thinMaterial)
        .cornerRadius(14)
    }
}

#Preview {
    let appSettings = AppSettings()
    SearchMenuActionView(onChangeUnit: {
        
    })
    .environment(appSettings)
}
