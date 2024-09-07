//
//  TButton.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct TButton: View {
    let text: String
    let config: TButtonConfig
    let didTap: () -> ()
    
    var body: some View {
        Button(action: {
            didTap()
        }, label: {
            let text = Text(text)
                .multilineTextAlignment(.center)
                .font(config.font)
            
            switch config.dimantions {
            case .none, .hagging:
                text
            case .full:
                text
                    .frame(maxWidth: .infinity)
            }
        })
        .buttonStyle(TButtonStyle(config: config))
        .disabled(!config.enabled)
    }
}

struct TButtonStyle: ButtonStyle {
    let config: TButtonConfig
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .padding(.top, 17)
            .padding(.bottom, 17)
            .foregroundStyle(
                withAnimation(.easeInOut) {
                    configuration.isPressed ? config.forgroundColor.opacity(0.8) : config.forgroundColor
                }
            )
            .background(
                withAnimation(.easeInOut) {
                    configuration.isPressed ? config.backroundColor.opacity(0.8) : config.backroundColor
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
            .overlay(
                withAnimation(.smooth) {
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .stroke(config.border.color,
                                lineWidth: config.border.width)
                }
            )
        
        switch config {
        case .selectebale(let selected, _, _):
            if selected {
                ZStack(alignment: .leading) {
                    label
                    Image("check_blue")
                        .resizable()
                        .frame(height: 24)
                        .frame(width: 24)
                        .padding(.top, 14)
                        .padding(.bottom, 14)
                        .padding(.leading, 38)
                }
            }
            else {
                label
            }
        default:
            label
        }
    }
}

#Preview {
    TButton(text: "אישור".localized(),
            config: .selectebale(selected: true,
                                 dimantions: .full,
                                 enabled: true)) {}
}
