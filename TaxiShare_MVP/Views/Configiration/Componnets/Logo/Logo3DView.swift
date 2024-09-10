//
//  Logo3dView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 05/09/2024.
//

import SwiftUI

struct Logo3DView: View {
    @State private var animate = false
    
    var title: AttributedString {
        let colors: [Color] = [
            .init(hex: "#D0C55C"),
            .init(hex: "#D1C556"),
            .init(hex: "#DED073"),
            .init(hex: "#E0D279"),
            .init(hex: "#E6D881"),
            .init(hex: "#EEDF7A")
        ]
        
        let string = "Shtaxi"
        
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            letterString.foregroundColor = colors[index % colors.count]
            result += letterString
        }
        
        result.font = .textHugeBold
        return result
    }
    
    var body: some View {
        if animate {
            PhaseAnimator([0, 1, 2, 3, 4]) { value in
                contnet(value: value)
            } animation: { value in return value > 1 && value < 4 ? .easeIn(duration: 0.5) : .smooth(duration: 0.5) }
        }
        else {
            contnet()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                        animate = true
                    }
                }
        }
    }
    
    @ViewBuilder private func contnet(value: Int = 0) -> some View {
        VStack(alignment: .center) {
            TLogo(shape: Rectangle(),
                  size: 128)
            .shadow(color: Color(hex: "#444122").opacity(0.9),
                    radius: 10,
                    x: value > 3 ? 0 : value > 2 ? -6 : value > 1 ? 6 : 0,
                    y: value > 3 ? 0 : value > 1 ? 6 : 0)
            .opacity(value > 0 ? 0.9 : 1)
            .padding(.top, -20)
            
            VStack(spacing: 4) {
                Text(title)
                    .shadow(color: Color(hex: "#444122").opacity(0.9),
                            radius: 4,
                            x: value > 3 ? 0 : value > 2 ? -6 : value > 1 ? 6 : 0,
                            y: value > 3 ? 0 : value > 1 ? 6 : 0)
                
                if animate {
                    TypingAnimationView(textToType: "Taxi Share App",
                                        value: value, 
                                        animationStage: 2)
                    .opacity(value > 2 ? 1 : (value > 1 ? 0.8 : 0))
                }
            }
            .padding(.top, -10)
        }
        .scaleEffect(x: value > 0 ? 1.8 : 1,
                     y: value > 0 ? 1.8 : 1,
                     anchor: .center)
    }
}


#Preview {
    Logo3DView()
}
