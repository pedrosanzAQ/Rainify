//
//  ContentView.swift
//  Rainify
//
//  Created by pedrosanz on 20/05/25.
//

import SwiftUI

struct CompassDraw: View {
    
    var direction: Int
    
    var radiusCompass: CGFloat? = 60
    var arrowWidth: CGFloat? = 20
    var arrowHeight: CGFloat? = 75
    
    private let largeTicks = Array(stride(from: 0, to: 360, by: 30))
    private let mediumTicks = Array(stride(from: 15, to: 360, by: 30))
    
    private let labeledPoints: [(label: String, angle: Double)] = [
        ("N", 0),
//        ("NE", 45),
        ("E", 90),
//        ("SE", 135),
        ("S", 180),
//        ("SW", 225),
        ("W", 270)
//        ("NW", 315)
    ]

    var body: some View {
        VStack{
            ZStack {
                // 360 ticks
                ForEach(0..<360, id: \.self) { degree in
                    CompassTickCustom(
                        angle: Angle(degrees: Double(degree)),
                        length: tickLength(for: degree),
                        lineWidth: lineWidth(for: degree),
                        radius: radiusCompass ?? 100
                    )
                }
                
                // Grado en los ticks grandes
                ForEach(largeTicks, id: \.self) { degree in
                    CompassDegreeLabel(degree: degree, radius: radiusCompass ?? 100, offset: 20)
                }
                
                // Direcciones cardinales principales
                ForEach(labeledPoints, id: \.label) { point in
                    CompassTextLabel(
                        text: point.label,
                        degree: point.angle,
                        radius: radiusCompass ?? 100,
                        offset: 12,
                        font: .headline
                    )
                }
                
                // Flecha roja
                ArrowTriangle()
                    .fill(Color.red)
                    .frame(width: arrowWidth, height: arrowHeight)
                    .rotationEffect(.degrees(Double(direction)))
            }
        }
        .frame(width: 180, height: 180)
    }

    func tickLength(for degree: Int) -> CGFloat {
        let big: CGFloat = 12
        let medium = big * 0.8       // 9.6
        let small = medium * 0.5     // 4.8

        if degree % 30 == 0 {
            return big
        } else if degree % 15 == 0 {
            return medium
        } else {
            return small
        }
    }

    func lineWidth(for degree: Int) -> CGFloat {
        if degree % 30 == 0 {
            return 2
        } else if degree % 15 == 0 {
            return 1.5
        } else {
            return 1
        }
    }
}

// MARK: - Tick View
struct CompassTickCustom: View {
    let angle: Angle
    let length: CGFloat
    let lineWidth: CGFloat
    let radius: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
            let startX = center.x + cos(CGFloat(angle.radians)) * (radius - length)
            let startY = center.y + sin(CGFloat(angle.radians)) * (radius - length)
            let endX = center.x + cos(CGFloat(angle.radians)) * radius
            let endY = center.y + sin(CGFloat(angle.radians)) * radius

            Path { path in
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(Color.gray.opacity(0.7), lineWidth: lineWidth)
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}

// MARK: - Grado numérico
struct CompassDegreeLabel: View {
    let degree: Int
    let radius: CGFloat
    let offset: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
            let angle = Angle(degrees: Double(degree - 90))
            let labelRadius = radius + offset

            let x = center.x + cos(CGFloat(angle.radians)) * labelRadius
            let y = center.y + sin(CGFloat(angle.radians)) * labelRadius
            
            let labelText: String = {
                switch degree {
                case 0: return ""
                case 90: return ""
                case 180: return ""
                case 270: return ""
                default: return "\(degree)°"
                }
            }()

            Text("\(labelText)")
                .font(.caption2)
                .position(x: x, y: y)
        }
    }
}

// MARK: - Etiquetas cardinales
struct CompassTextLabel: View {
    let text: String
    let degree: Double
    let radius: CGFloat
    let offset: CGFloat
    let font: Font

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
            let angle = Angle(degrees: degree - 90)
            let labelRadius = radius + offset

            let x = center.x + cos(CGFloat(angle.radians)) * labelRadius
            let y = center.y + sin(CGFloat(angle.radians)) * labelRadius

            Text(text)
                .font(font)
                .fontWeight(text == "N" ? .bold : .regular)
                .position(x: x, y: y)
        }
    }
}

// MARK: - Flecha roja
struct ArrowTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tip = CGPoint(x: rect.midX, y: rect.minY)
        let tail = CGPoint(x: rect.midX, y: rect.maxY)
        let left = CGPoint(x: rect.midX - rect.width * 0.3, y: rect.maxY * 0.7)
        let right = CGPoint(x: rect.midX + rect.width * 0.3, y: rect.maxY * 0.7)

        path.move(to: tip)
        path.addLine(to: right)
        path.addLine(to: tail)
        path.addLine(to: left)
        path.closeSubpath()

        return path
    }
}

#Preview {
    CompassDraw(direction: 80)
        
}
