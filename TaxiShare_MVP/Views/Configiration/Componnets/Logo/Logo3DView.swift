//
//  Logo3dView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 05/09/2024.
//

import SwiftUI

struct Logo3DView: View {
    private var title: AttributedString {
        let colors: [Color] = [
            .init(hex: "#D0C55C"),
            .init(hex: "#D1C556"),
            .init(hex: "#DED073"),
            .init(hex: "#E0D279"),
            .init(hex: "#E6D881"),
            .init(hex: "#EEDF7A")
        ]
        
        let string = "שטקסי".localized()
        
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            letterString.foregroundColor = colors[index % colors.count]
            result += letterString
        }
        
        result.font = .textHugeBold
        return result
    }
    
    private var startAnimation: () -> () { { animate = true } }
    
    @State private var animate = false
    
    var body: some View {
        if animate {
            PhaseAnimator([0, 1, 2, 3, 4, 5],
                          content: contnet,
                          animation: animation)
        }
        else {
            contnet()
                .onAppear(perform: onAppear)
        }
    }
    
    private func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2,
                                      execute: startAnimation)
    }
    
    private func animation(value: Int) -> Animation? {
        return value == 3 ? .smooth(duration: 1.2) : .easeInOut(duration: 0.6)
    }
    
    @ViewBuilder private func glareAnimation(step: Int) -> some View {
        let progress: CGFloat = step > 0 && step < 5 ? 1 : 0
        RoundedRectangle(cornerRadius: 10)
            .trim(from: .zero,
                  to: progress)
            .glow(fill: .yellowGradient,
                lineWidth: 2)
            .frame(width: 124)
            .frame(height: 2)
            .opacity(0.1)
            .shadow(color: Color(hex: "#444122"),
                    radius: 2,
                    x: step > 4 || step == 3 ? 0 : step > 3 ? -5 : step > 1 ? 5 : 0,
                    y: step > 4 || step == 3 ? 0 : step > 1 ? 5 : 0)
            .animation(.linear(duration: 0.2),
                       value: true)
    }
    
    @ViewBuilder private func logo(step: Int) -> some View {
        TLogo(shape: Rectangle(),
              size: 220)
        .opacity(0.1)
        .shadow(color: Color(hex: "#444122"),
                radius: 2,
                x: step > 4 || step == 3 ? 0 : step > 3 ? -5 : step > 1 ? 5 : 0,
                y: step > 4 || step == 3 ? 0 : step > 1 ? 5 : 0)
    }
    
    @ViewBuilder private func title(step: Int) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.tTitle)
                .opacity(0.1)
                .shadow(color: Color(hex: "#444122"),
                        radius: 2,
                        x: step > 4 || step == 3 ? 0 : step > 3 ? -5 : step > 1 ? 5 : 0,
                        y: step > 4 || step == 3 ? 0 : step > 1 ? 5 : 0)
            
            glareAnimation(step: step)
        }
        .padding(.bottom, 8)
    }
    
    @ViewBuilder private func animateText(step: Int) -> some View {
        TypingAnimationView(textToType: "אפליקציה לשיתוף נסיעה במונית".localized(),
                            value: step,
                            animationStage: 2,
                            nextAnimtionDaley: 2)
        .opacity(step > 1 ? 0.2 : 0)
    }
    
    @ViewBuilder private func top(step: Int) -> some View {
        VStack(spacing: 4) {
            title(step: step)
            animateText(step: step)
        }
        .padding(.bottom, 8)
    }
    
    @ViewBuilder private func contnet(step: Int = 0) -> some View {
        ZStack {
            VStack {
                top(step: step)
                logo(step: step)
            }
            .scaleEffect(x: step > 0 ? 1.8 : 1.6,
                         y: step > 0 ? 1.8 : 1.6,
                         anchor: .center)
            .padding(.top, -40)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background {
            let colors: [Color] = [.init(hex: "#fef678").opacity(0.2), .init(hex:"#fdff00").opacity(0.2), .init(hex:"#ffe833").opacity(0.2),.init(hex:"#ffc566").opacity(0.2), .init(hex:"#ffb640").opacity(0.2)].shuffled()
            LinearGradient(gradient: Gradient(colors: colors),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .animation(.smooth,
                       value: true)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Logo3DView()
}
