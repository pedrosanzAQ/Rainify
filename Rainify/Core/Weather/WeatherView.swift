//
//  WeatherView.swift
//  Rainify
//
//  Created by pedrosanz on 15/03/25.
//

import SwiftUI

struct WeatherView: View {
//    private var countries:[String] = ["Mexico", "Spain", "Japan"]
    private var countries: [String] = ["Mexico"]
    @State private var cloudScene: CloudScene7? = nil
    
    @State var scrollOffset: CGFloat = 0
    
    // Constantes para controlar los efectos
        private let fadeStartOffset: CGFloat = 0
        private let fadeEndOffset: CGFloat = -80
        private let headerAppearOffset: CGFloat = -40 // Aparece antes que el fade completo
    
    var body: some View {
        GeometryReader { geo in
            if countries.count > 1 {
                TabView {
                    ForEach(self.countries, id: \.self) { country in
                        Text(country)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .background(Color.blue)
                    }
                }
                .tabViewStyle(.page)
            } else {
                ZStack(alignment: .top) {
                    
                    ScrollView {
                        GeometryReader { geometry in
                            Color.clear
                            .onChange(of: geometry.frame(in: .global).minY) { oldVaue, newValue in
                                scrollOffset = newValue
//                                    print("Scroll offset: \(scrollOffset)")
                            }
                        }
                        .frame(height: 0)
                            
                        VStack(spacing: 16) {
                            ForEach(0..<20) { i in
                                Text("Elemento \(scrollOffset)")
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                        }
                        .padding(.top)
                    }
                    .background(Color.green.opacity(0.3))
                    .zIndex(1)
                    
//                    if cloudScene != nil {
//                        FadeOverlayView(progress: fadeProgress, scene: cloudScene)
//                            .frame(height: 130)
//                            .ignoresSafeArea(edges: .top)
//                            .zIndex(3)
//                        
//                        if headerProgress > 0.99 {
//                            WeatherHeaderView(
//                                title: "Mexico City",
//                                humidity: 76,
//                                temperature: 23,
//                                feelsLike: 18,
//                                progress: headerProgress,
////                                scene: scene
//                                //                            progress: headerProgress > 0.99 ? 1 : 0 // solo animación de entrada
//                            )
//                            .opacity(headerProgress)
//                            .transition(.move(edge: .top).combined(with: .opacity))
//                            .animation(.easeInOut(duration: 0.4), value: headerProgress)
//                            .zIndex(3)
//                        }
//                    }
                    
                }
                .onAppear {
                    if cloudScene == nil {
                        _ = CGSize(width: geo.size.width, height: 150)
//                        cloudScene = CloudScene7(size: size)
                    }
                }
            }
        }
    }
    
    // Fade aparece más rápido
        private var fadeProgress: Double {
            let start: CGFloat = 0
            let end: CGFloat = -80
            let raw = (scrollOffset - start) / (end - start)
            return max(0, min(1, Double(raw)))
        }
        
        // Header aparece un poco más abajo
        private var headerProgress: Double {
            let start: CGFloat = 0
            let end: CGFloat = -80
            let raw = (scrollOffset - start) / (end - start)
            return max(0, min(1, Double(raw)))
        }
}

#Preview {
    NavigationStack{
        WeatherView()
    }
}
