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
        let colors: [Color] = [.init(hex: "#DCCF23"), .init(hex: "#B8AD16"), .init(hex: "##9B920E"), .init(hex: "#857D07"), .init(hex: "#6E6E04"), .init(hex: "#575A01")]
        
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
            PhaseAnimator([0, 1, 2, 3]) { value in
                contnet(value: value)
            } animation: { value in return .smooth(duration: 0.74) }
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
            .shadow(color: Color(hex: "#444122").opacity(0.8),
                    radius: 10,
                    x: value > 0 ? 10 : 4,
                    y: value > 0 ? 10 : 4)
            .opacity(value > 0 ? 0.9 : 1)
            .padding(.top, -70)
            
            VStack(spacing: 4) {
                Text(title)
                    .shadow(color: Color(hex: "#444122").opacity(0.8),
                            radius: 4,
                            x: value > 0 ? 10 : 4,
                            y: value > 0 ? 10 : 4)
                
                if animate {
                    TypingAnimationView(textToType: "Taxi Share App", 
                                        value: value, 
                                        animationStage: 2)
                        .opacity(value > 2 ? 1 : (value > 1 ? 0.8 : 0))
                }
            }
            .padding(.top, -10)
        }
        .scaleEffect(x: value > 0 ? 1.4 : 1,
                     y: value > 0 ? 1.4 : 1,
                     anchor: .center)
    }
}


#Preview {
    Logo3DView()
}
