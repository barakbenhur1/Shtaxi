//
//  TProgressBar.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct TProgressBar: View {
    let text: String
    let total: Int
    @Binding var value: Int
    
    var body: some View {
        VStack {
            HStack {
                Image("check")
                    .resizable()
                    .frame(height: 24)
                    .frame(width: 24)
                
                Text("\("שלבים") \(value + 1)/\(total)")
                    .font(Custom.shared.font.textMedium)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text(text)
                    .font(Custom.shared.font.button)
                    .multilineTextAlignment(.center)
            }
            
            TProgressBarView(value: $value,
                         total: total)
        }
        .frame(height: 48)
    }
}

struct TProgressBarView: View {
    @Binding var value: Int
    let total: Int
    
    var body: some View {
        GeometryReader { geometry in
            let progress = (geometry.size.width / CGFloat(total)) * CGFloat(value + 1)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 79)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: 12)
                    .frame(maxWidth: .infinity)
                
                RoundedRectangle(cornerRadius: 79)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Custom.shared.color.progressStart, Custom.shared.color.progressEnd]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .frame(width: progress)
//                    .animation(.linear, value: value)
            }
        }
    }
}

//#Preview {
//    TProgressBar(value: .constant(0),
//                 total: 4,
//                 text: .constant("עוד רגע שם.."))
//}
