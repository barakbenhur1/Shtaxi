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
    @State private var drive = false
    
    var translucent: Bool = false
    
    private let main = DispatchQueue.main
    
    @ViewBuilder
    private var title: some View {
        Text("שטקסי")
            .foregroundStyle(Color(hex: "#686868"))
            .font(.tTitle)
            .opacity(firstAnimation ? 0.8 : 0.04)
            .padding(.bottom, 200)
            .padding(.leading, -106)
    }
    
    @ViewBuilder
    private var wheel: some View {  // Mark 3
        Image(systemName: "circle.grid.hex.fill")
            .resizable()
            .scaledToFit()
            .opacity(0.8)
            .frame(width: 74,
                   height: 74)
            .rotationEffect(Angle(degrees: degreesRotating)) // Mark 4
            .scaleEffect(secondAnimation ? 0 : 1) // Mark 4
    }
    
    @ViewBuilder
    private var taxi: some View {  // Mark 3
        GeometryReader {
            let size = $0.size
            Image(drive ? "taxi_launch_off" : "taxi_launch")
                .resizable()
                .scaledToFit()
                .frame(height: 400)
                .frame(width: size.width - 18)
                .opacity(firstAnimation ? 0.4 : 0.02)
                .padding(.leading, 18)
        }
        .padding(.top, 146)
    }
    
    @ViewBuilder
    private var backgroundColor: some View {  // Mark 3
        Color(hex: "#f6c600")
            .opacity(0.8)
            .ignoresSafeArea()
    }
    
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
            .offset(x: secondAnimation ? 600 : 0)
        }
        .background(.white)
        .ignoresSafeArea()
        .task { updateAnimation() }
        .onChange(of: launchScreenState.state,
                  updateAnimation)
        .opacity(startFadeoutAnimation ? 0 : 1)
        .onAppear {
            withAnimation(.linear(duration: 0.6)
                .repeatForever(autoreverses: false)) {
                    degreesRotating = 360
                }
            withAnimation(.easeInOut(duration: 4)) {
                firstAnimation = true
            }
        }
    }
    
    private func updateAnimation() { // Mark 5
        switch launchScreenState.state {
        case .firstStep:
            launchScreenState.sleep = 2.94
        case .secondStep:
            withAnimation(.easeOut(duration: 0.8)) {
                drive = true
            }
            main.asyncAfter(wallDeadline: .now() + 0.74) {
                if secondAnimation == false {
                    withAnimation(.linear(duration: 0.6)) {
                        secondAnimation = true
                    }
                    main.asyncAfter(wallDeadline: .now() + 0.4) {
                        withAnimation(.easeInOut(duration: 1.8)) {
                            startFadeoutAnimation = true
                        }
                    }
                }
            }
            
        case .finished:
            break
        }
    }
}
