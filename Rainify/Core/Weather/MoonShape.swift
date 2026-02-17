//
//  MoonShape.swift
//  Rainify
//
//  Created by pedrosanz on 31/05/25.
//

import SwiftUI

struct MoonShape: View {
    var phase: String
    
    var body: some View {
        if let uiImage = UIImage(named: phase.moonImageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 10)
                .brightness(0.036) // 0.1 a 0.3 es ideal
//                .frame(width: 180, height: 190)
        }
    }
}


#Preview {
//    @Previewable @State var phases: String = "Full Moon"
//    @Previewable @State var phases: String = "Waning Crescent"
//    @Previewable @State var phases: String = "last quarter"
//    @Previewable @State var phases: String = "new moon"
    @Previewable var phases: String = "Waxing gibbous"
    MoonShape(phase: phases)
}
