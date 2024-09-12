//
//  LuanchScreen.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 12/09/2024.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager // Mark 1
    
    @State private var degreesRotating = 0.0
    @State private var firstAnimation = false  // Mark 2
    @State private var secondAnimation = false // Mark 2
    @State private var startFadeoutAnimation = false // Mark 2
    
    @ViewBuilder
    private var title: some View {
        Text("שטקסי")
            .foregroundStyle(Color(hex: "#686868"))
            .font(.tTitle)
            .opacity(firstAnimation ? 0.4 : 0.04)
            .padding(.bottom, 214)
            .padding(.leading, -110)
    }
    
    @ViewBuilder
    private var wheel: some View {  // Mark 3
        Image(systemName: "circle.grid.hex.fill")
            .resizable()
            .scaledToFit()
            .opacity(0.8)
            .frame(width: 80,
                   height: 80)
            .rotationEffect(Angle(degrees: degreesRotating)) // Mark 4
            .scaleEffect(secondAnimation ? 0 : 1) // Mark 4
    }
    
    @ViewBuilder
    private var taxi: some View {  // Mark 3
        Image("taxi_launch")
            .resizable()
            .scaledToFit()
            .frame(height: 400)
            .frame(width: !secondAnimation ? 420 : 400)
            .opacity(firstAnimation ? 0.4 : 0.02)
            .padding(.leading, 18)
            .padding(.bottom, 176)
    }
    
    @ViewBuilder
    private var backgroundColor: some View {  // Mark 3
        Color(hex: "#f6c600")
            .opacity(0.8)
            .ignoresSafeArea()
    }
    
    private let animationTimer = Timer // Mark 5
        .publish(every: 0.5,
                 on: .current,
                 in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor  // Mark 3
            ZStack {
                title
                ZStack {
                    taxi
                    wheel  // Mark 3
                }
                .shadow(radius: 1,
                        x: -2,
                        y: 2)
            }
            .offset(x: secondAnimation ? 400 : 0)
        }
        .background(.white)
        .ignoresSafeArea()
        .task { updateAnimation() }
        .onReceive(animationTimer) { _ in updateAnimation() }
        .opacity(startFadeoutAnimation ? 0 : 1)
        .onAppear {
            withAnimation(.linear(duration: 0.7)
                .repeatForever(autoreverses: false)) {
                    degreesRotating = 360
                }
            withAnimation(.easeInOut(duration: 4)
                .repeatForever(autoreverses: true)) {
                    firstAnimation = true
                }
        }
    }
    
    private func updateAnimation() { // Mark 5
        switch launchScreenState.state {
        case .firstStep, .finished:
            break
        case .secondStep:
            animationTimer
                .upstream
                .connect()
                .cancel()
            if secondAnimation == false {
                withAnimation(.linear(duration: 0.34)) {
                    secondAnimation = true
                }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 2)) {
                        startFadeoutAnimation = true
                    }
                }
            }
        }
    }
    
}
