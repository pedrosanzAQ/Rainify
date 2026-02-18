//
//  ContentBoxView.swift
//  Rainify
//
//  Created by pedrosanz on 29/05/25.
//

import SwiftUI

struct ContentBoxView<Content: View>: View {
    let title: String
    let subtitle: String?
    let isOverlayStyle: Bool
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    
    init(title: String, subtitle: String? = nil, isOverlayStyle: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.isOverlayStyle = isOverlayStyle
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            content()
                .padding()
                .background(
                    isOverlayStyle ?
                    AnyView(specialBackground) :
                    AnyView(Color.white.opacity(colorScheme == .dark ? 0.03 : 1))
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            colorScheme == .dark ?
                                Color.white.opacity(0.25) :
                                Color.black.opacity(0.1),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: colorScheme == .dark ?
                        Color.white.opacity(0.20):
                        Color.black.opacity(0.13),
                    radius: 6, x: 0, y: 2
                )
            
            HStack(spacing: -2){
                Text(title)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        isOverlayStyle
                        ? AnyView(specialBackground) :
                        AnyView(Color(.systemBackground))
                    )
                    .cornerRadius(8)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .padding(.trailing, 10)
                        .padding(.vertical, 4)
                        .cornerRadius(8)
                }
            }
            .overlay(
                Rectangle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0)
            )
            .padding(.leading, 15)
            .padding(.top, -8)

            
        }
    }
    
    var specialBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial.opacity(0.9))
    }

}
#Preview("title"){
    ContentBoxView(title: "Air Condition") {
        VStack{
            Text("Hello world")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .padding(.horizontal)
    .frame(width: 300, height: 280)
}

#Preview("title"){
    ContentBoxView(title: "Air Condition", isOverlayStyle: true) {
        VStack{
            Text("Hello world")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .padding(.horizontal)
    .frame(width: 300, height: 280)
}

#Preview("titleSubtitle"){
    ContentBoxView(title: "Air Condition", subtitle: "Waxios gibbous") {
        VStack{
            Text("Hello world")
        }
        .frame(maxWidth: .infinity)
    }
    .padding(.horizontal)
}
