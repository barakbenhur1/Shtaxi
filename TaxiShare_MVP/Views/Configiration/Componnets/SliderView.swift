//
//  SliderView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 29/06/2024.
//

import SwiftUI

struct SliderView: View {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    @Binding var value: CGFloat
    
    var body: some View {
        if minimumValue < maximumValue {
            VStack {
                Text("\(Int(value))")
                Slider(value: $value, in: minimumValue...maximumValue, step: 1) {
                    
                } minimumValueLabel: {
                    Text("\(Int(minimumValue))")
                        .padding(.trailing, 8)
                } maximumValueLabel: {
                    Text("\(Int(maximumValue))")
                        .padding(.leading, 8)
                }
            }
        }
    }
}
