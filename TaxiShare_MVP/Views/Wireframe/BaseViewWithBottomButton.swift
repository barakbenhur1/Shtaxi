//
//  OnboaredingBaseView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct BaseViewWithBottomButton<Contant: View>: View {
    @Binding var buttonConfig: TButtonConfig
    @Binding var loading: Bool
    let buttonText: String
    let contant: Contant
    let didApprove: () -> ()
    
    var body: some View {
        ZStack {
            VStack {
                contant
                Spacer()
                TButton(text: buttonText,
                        config: buttonConfig) {
                    hideKeyboard()
                    didApprove()
                }
            }
            .padding(.top, 68)
            .padding(.bottom, 72)
            .padding(.horizontal, 40)
            .ignoresSafeArea()
            .disabled(loading)
            
            if loading { loadingView() }
        }
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
            .tint(.yellow.opacity(0.8))
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
    }
}
