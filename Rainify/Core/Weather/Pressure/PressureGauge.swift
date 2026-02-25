//
//  PressureGauge.swift
//  Rainify
//
//  Created by pedrosanz on 20/05/25.
//

import SwiftUI

struct PressureGaugeView: View {
    var viewmodel: PressureGaugeViewModel

    var body: some View {
        ContentBoxView(title: "Pressure"){
            if viewmodel.hasData {
                ZStack {
                    let angle = viewmodel.getAnglePressure()
                    
                    Circle()
                        .trim(from: 0.25, to: 0.75)
                        .stroke(Color.gray.opacity(0), lineWidth: 15)
                        .frame(width: viewmodel.radius * 2, height: viewmodel.radius * 2)
                    
                    ForEach(0..<viewmodel.tickCount, id: \.self) { index in
                        let angle = Angle(degrees: viewmodel.startAngle + (Double(index) / Double(viewmodel.tickCount - 1)) * (viewmodel.endAngle - viewmodel.startAngle))
                        TickMark(angle: angle, radius: viewmodel.radius)
                    }
                    
                    Text("Low")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .offset(viewmodel.getOffset(for: viewmodel.startAngle, distance: viewmodel.radius + 20))
                    
                    Text("High")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .offset(viewmodel.getOffset(for: viewmodel.endAngle, distance: viewmodel.radius + 20))
                    
                    VStack(spacing: 1){
                        Text("\(String(format: "%.1f", viewmodel.pressure ?? 0))") //mb or inHg
                        
                        Text("inHg")
                    }
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .offset(x: -viewmodel.radius * 0.85)
                    
                    NeedleWithValue(angle: angle, pressure: viewmodel.pressure ?? 0, radius: viewmodel.radius)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                WithoutConnectionView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct ArrowWithSemiBase: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Tamaños
        let triangleHeight = rect.height * 0.7
        _ = rect.height - triangleHeight
        let centerX = rect.midX

        path.move(to: CGPoint(x: centerX, y: 0))
        path.addLine(to: CGPoint(x: centerX + rect.width / 2, y: triangleHeight))
        path.addLine(to: CGPoint(x: centerX - rect.width / 2, y: triangleHeight))
        path.closeSubpath()

        path.addArc(
            center: CGPoint(x: centerX, y: triangleHeight),
            radius: rect.width / 2,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: false
        )

        return path
    }
}


struct NeedleWithValue: View {
    var angle: Double
    var pressure: Double
    var radius: CGFloat

    var body: some View {
        ZStack {
            ArrowWithSemiBase()
                .fill(Color.red)
                .frame(width: 18, height: radius * 1.2)
        }
        .rotationEffect(.degrees(angle))
        .animation(.easeInOut(duration: 0.2), value: angle)
    }
}

struct TickMark: View {
    let angle: Angle
    let radius: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            let start = CGPoint(
                x: center.x + cos(CGFloat(angle.radians)) * (radius - 5),
                y: center.y + sin(CGFloat(angle.radians)) * (radius - 5)
            )

            let end = CGPoint(
                x: center.x + cos(CGFloat(angle.radians)) * radius,
                y: center.y + sin(CGFloat(angle.radians)) * radius
            )

            Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            .stroke(Color.primary, lineWidth: 2)
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}

#Preview("Data") {
    if let weather = Bundle.main.decode("MockWeatherResponse.json") as WeatherResponse? {
        let mockCurrent = weather.current
        PressureGaugeView(viewmodel: PressureGaugeViewModel(weather: mockCurrent))
            .frame(width: 180, height: 180)
    }
}

#Preview("NoData") {
    PressureGaugeView(viewmodel: PressureGaugeViewModel(weather: nil))
        .frame(width: 180, height: 180)
}
