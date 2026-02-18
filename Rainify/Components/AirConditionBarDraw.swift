//
//  AirConditionBarDraw.swift
//  Rainify
//
//  Created by pedrosanz on 28/05/25.
//

import SwiftUI

struct AirConditionBarDraw: View {
    
    var barWidth:CGFloat
    let minRange: Double
    let maxRange: Double
    let value: Double
    var colorBar: [Color]
    var showNumbers: Bool? = false
    
    private var totalSections: Int { Int(minRange + maxRange) }
    private var totalDividers: Int { Int(maxRange) }
        
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                // Complete bar
                Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colorBar),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: barWidth - 32 , height: 10)
                
                // stick indicator
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 5, height: 25)
                    .offset(x: offsetIndicator() - 1)
                    .shadow(color: .white.opacity(0.6), radius: 8, x: 0, y: 0)
                    .blur(radius: 0.3)
            }
        }
    }
    
    // Gives horizontal position of white mark
        private func offsetIndicator() -> CGFloat {
            let usableWidth = barWidth - 32
            let clampedValue = min(max(value, minRange), maxRange)
            let percentage = (clampedValue - minRange) / (maxRange - minRange)
            return CGFloat(percentage) * usableWidth
        }

}

#Preview {
    AirConditionBarDraw(barWidth: UIScreen.main.bounds.width - 32, minRange: 1, maxRange: 10, value: (3.0), colorBar: [.green, .yellow, .orange, .red], showNumbers: true)
}
