// SplashView.swift
// traveleasy
// Created by Assistant

import SwiftUI

struct SplashView: View {
    @Binding var isFinished: Bool
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.9), Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Group {
                    if let uiImage = UIImage(named: "AppLogo") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                            .scaleEffect(animate ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: animate)
                    } else {
                        Image(systemName: "airplane.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .white.opacity(0.7))
                            .font(.system(size: 88))
                            .scaleEffect(animate ? 1.0 : 0.8)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                            .rotationEffect(.degrees(animate ? 0 : -8))
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: animate)
                    }
                }

                Text("TravelEasy")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .opacity(animate ? 1 : 0.6)

                Text("Your trip, simplified")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)
                    .padding(.top, 8)
            }
            .padding()
        }
        .onAppear {
            animate = true
            // Simulate loading, then finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut) {
                    isFinished = true
                }
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isFinished in
        SplashView(isFinished: isFinished)
    }
}

// Utility to preview bindings easily
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
