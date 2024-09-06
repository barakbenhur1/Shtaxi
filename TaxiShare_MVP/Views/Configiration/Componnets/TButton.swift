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
            
            switch config {
            case .none:
                text
            case .defulat(_, let dimantions):
                switch dimantions {
                case .none, .hagging:
                    text
                case .full:
                    text
                        .frame(maxWidth: .infinity)
                }
            }
            
        })
        .buttonStyle(TButtonStyle(config: config))
        .disabled(config.rawValue.state.isDisabled())
    }
}

struct TButtonStyle: ButtonStyle {
    let config: TButtonConfig
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .padding(.top, 17)
            .padding(.bottom, 17)
            .multilineTextAlignment(.center)
            .font(config.rawValue.font)
            .foregroundStyle(
                withAnimation {
                    configuration.isPressed ? config.rawValue.state.getForgroundColor().opacity(0.8) : config.rawValue.state.getForgroundColor()
                }
            )
            .background(
                withAnimation {
                    configuration.isPressed ? config.rawValue.state.getBackroundColor().opacity(0.8) :
                    config.rawValue.state.getBackroundColor()
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: config.rawValue.cornerRadius))
        
        switch config {
        case .none:
            label
        case .defulat(let state, _):
            switch state {
            case .selectebale(let selected):
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
                    .overlay(
                        RoundedRectangle(cornerRadius: config.rawValue.cornerRadius)
                            .stroke(Custom.shared.color.tBlue,
                                    lineWidth: 1)
                    )
                }
                else {
                    label
                        .overlay(
                            RoundedRectangle(cornerRadius: config.rawValue.cornerRadius)
                                .stroke(Custom.shared.color.darkText,
                                        lineWidth: 1)
                        )
                }
            default:
                label
            }
        }
    }
}

#Preview {
    TButton(text: "אישור".localized(),
            config: .defulat(state: .selectebale(selected: true),
                             dimantions: .full)) {
        
    }
}
