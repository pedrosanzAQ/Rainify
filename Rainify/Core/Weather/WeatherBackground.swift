//
//  HeroCellView.swift
//  Rainify
//
//  Created by pedrosanz on 23/06/25.
//

import SwiftUI
import SpriteKit

struct WeatherBackground: View {
    @Environment(\.colorScheme) var colorScheme
    let scene: CloudScene7

    var body: some View {
        ZStack(alignment: .top) {
            // Imagen de fondo
            Image("rainyWeather")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
//                .ignoresSafeArea()
            
            TransparentCloudsView(
                height: 350,
                background: .clear,
                scene: scene
            )
            .frame(height: 350)
            .clipped()
            
            
            // Gradiente adaptativo
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
//            .ignoresSafeArea()

        }
    }
    
    /// Colores que se adaptan al modo claro/oscuro
        var gradientColors: [Color] {
            if colorScheme == .dark {
                return [
//                    Color.black.opacity(0.2), // más claro arriba
                    Color.black.opacity(0.4), // más oscuro abajo
                    Color.black.opacity(0.6), // más oscuro abajo
                    Color.black.opacity(0.8), // más oscuro abajo
//                    Color.black                // opaco abajo
                ]
            } else {
                return [
                    Color.white.opacity(0.2), // más claro arriba
                    Color.white.opacity(0.4), // más oscuro abajo
                    Color.white.opacity(0.6),
                    Color.white.opacity(0.8),
                    Color.white.opacity(0.9),
                    Color.white                // opaco abajo
                ]
            }
        }
}

#Preview {
    var clouds = CloudScenes()
    WeatherBackground(scene: clouds.bigScene)
}
