//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 18/03/25.
//

import Foundation
import SwiftUI


extension Color {
    static let theme = ColorTheme()
    

}


struct ColorTheme {
    let primary = Color("AccentColor")
    let secondary = Color("SecondaryText")
    
    var dinamicText: Color {
            Color(UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    // gris claro sobre fondo oscuro (menos fuerte que blanco puro)
                    return UIColor(.white.opacity(0.85))
                default:
                    // gris oscuro suave sobre fondo claro (menos fuerte que negro puro)
                    return UIColor(.black.opacity(0.85))
                }
            })
        }}

