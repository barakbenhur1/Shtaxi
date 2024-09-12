//
//  View+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 19/08/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

extension View where Self: Shape {
    func glow(
        fill: some ShapeStyle,
        lineWidth: Double,
        blurRadius: Double = 1.0,
        lineCap: CGLineCap = .round
    ) -> some View {
        self
            .stroke(style: StrokeStyle(lineWidth: lineWidth / 2, 
                                       lineCap: lineCap,
                                       lineJoin: .miter))
            .fill(fill)
            .overlay {
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                               lineCap: lineCap,
                                               lineJoin: .miter))
                    .fill(fill)
                    .blur(radius: blurRadius)
            }
            .overlay {
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, 
                                               lineCap: lineCap,
                                               lineJoin: .miter))
                    .fill(fill)
                    .blur(radius: blurRadius / 2)
            }
    }
}

extension ShapeStyle where Self == AngularGradient {
    static var palette: some ShapeStyle {
        .angularGradient(
            stops: [
                .init(color: .blue, location: 0.0),
                .init(color: .purple, location: 0.2),
                .init(color: .red, location: 0.4),
                .init(color: .mint, location: 0.5),
                .init(color: .indigo, location: 0.7),
                .init(color: .pink, location: 0.9),
                .init(color: .blue, location: 1.0),
            ],
            center: .center,
            startAngle: Angle(radians: .zero),
            endAngle: Angle(radians: .pi * 2)
        )
    }
    
    static var yellowGradient: some ShapeStyle {
        .angularGradient(
            stops: [
                .init(color: .init(hex: "#D0C55C"), location: 0),
                .init(color: .init(hex: "#D1C556"), location: 0.2),
                .init(color: .init(hex: "#DED073"), location: 0.4),
                .init(color: .init(hex: "#E0D279"), location: 0.6),
                .init(color: .init(hex: "#E6D881"), location: 0.8),
                .init(color: .init(hex: "#EEDF7A"), location: 1),
            ],
            center: .center,
            startAngle: Angle(radians: .zero),
            endAngle: Angle(radians: .pi * 2)
        )
    }
}
