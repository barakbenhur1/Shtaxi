//
//  Modifiers.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct ViewWithButton: ViewModifier {
    @StateObject var buttonConfigManager = TButtonConfigManager(buttonConfig: .designed(dimantions: .full,
                                                                                        enabled: false))
    
    @State private var loading = false
    let buttonText: String
    let preformAction: (_ success: @escaping (Bool) -> ()) -> ()
    @Binding var loadingForExternalActions: Bool?
    @Binding var setButtonConfig: Bool
    let onTapGesture: (() -> ())?
    
    func body(content: Content) -> some View {
        let view = BaseViewWithBottomButton(buttonConfig: $buttonConfigManager.buttonConfig,
                                            loading: $loading,
                                            buttonText: buttonText,
                                            contant: content)
        {
            loading = true
            preformAction { _ in loading = false }
        }
        .onChange(of: loadingForExternalActions, setLoading)
        .onChange(of: setButtonConfig, configButton)
        
        if let onTapGesture {
            view
                .contentShape(Rectangle())
                .onTapGesture { onTapGesture() }
        }
        else {
            view
        }
    }
    
    private func setLoading() -> Void {
        guard let loadingForExternalActions else { return  loading = false }
        loading = loadingForExternalActions
    }
    
    private func configButton() {
        withAnimation(.smooth) {
            buttonConfigManager.buttonConfig = .designed(dimantions: .full,
                                                         enabled: setButtonConfig)
        }
    }
}

extension View {
    func wrapWithBottun(buttonText: String, preformAction: @escaping (_ success: @escaping (Bool) -> ()) -> (), loadingForExternalActions: Binding<Bool?>? = nil, setButtonConfig: Binding<Bool>, onTapGesture: (() -> ())? = nil) -> some View {
        modifier(ViewWithButton(buttonText: buttonText,
                                preformAction: preformAction,
                                loadingForExternalActions: loadingForExternalActions ?? .constant(nil),
                                setButtonConfig: setButtonConfig,
                                onTapGesture: onTapGesture))
    }
}
