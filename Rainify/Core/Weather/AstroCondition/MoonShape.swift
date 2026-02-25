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
                .brightness(0.036)
        }
    }
}


#Preview {
    @Previewable var phases: String = "Waxing gibbous"
    MoonShape(phase: phases)
}
