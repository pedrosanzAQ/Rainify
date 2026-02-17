//
//  Test.swift
//  Rainify
//
//  Created by pedrosanz on 19/01/26.
//
import SwiftUI

struct Test: View {
    
    let fruits = ["Apple", "Banana", "Strawberry", "Orange", "Pineapple"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(fruits, id: \.self) { fruit in
                        SwipeRow(
                            height: 120,
                            onDelete: { print("Delete \(fruit)") }
                        ) {
                            HStack {
                                Text(fruit)
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .frame(height: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 2)
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.red.opacity(0.2)) // fondo visible detrás de los swipes
            .navigationTitle("Recents")
        }
    }
}

struct SwipeRow<Content: View>: View {
    
    let height: CGFloat
    let onDelete: () -> Void
    let content: Content
    
    @State private var offsetX: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isDraggingHorizontally = false
    
    init(height: CGFloat,
         onDelete: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.height = height
        self.onDelete = onDelete
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Fondo rojo detrás del swipe
            HStack {
                Spacer()
                Button {
                    onDelete()
                    close()
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 90, height: height)
                        .background(Color.red)
                        .cornerRadius(14)
                }
            }
            
            // Contenido deslizable
            content
                .offset(x: offsetX + dragOffset)
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .updating($dragOffset) { value, state, _ in
                            // Detectar dirección solo una vez
                            if !isDraggingHorizontally {
                                isDraggingHorizontally = abs(value.translation.width) > abs(value.translation.height)
                            }
                            if isDraggingHorizontally {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if isDraggingHorizontally {
                                if value.translation.width < -60 {
                                    offsetX = -90
                                } else {
                                    close()
                                }
                            }
                            isDraggingHorizontally = false
                        }
                )
                .animation(.interactiveSpring(), value: offsetX)
        }
        .frame(height: height)
        .clipped()
    }
    
    private func close() {
        offsetX = 0
    }
}

#Preview {
    Test()
}
