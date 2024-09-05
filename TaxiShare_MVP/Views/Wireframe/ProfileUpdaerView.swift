//
//  ProfileCreationView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 02/09/2024.
//

import SwiftUI

struct ProfileUpdaerView<Content: ActionableView>: View {
    @EnvironmentObject var manager: PersistenceController
    
    @State private var loading = false
    
    @State private var buttonConfig: TButtonConfig = .defulat(state: .disabled,
                                                              dimantions: .full)
    
    let buttonText: String
    
    @State var content: Content
    
    let didApprove: () -> ()
    
    var body: some View {
        BaseViewWithBottomButton(buttonConfig: $buttonConfig,
                                 loading: $loading,
                                 buttonText: buttonText,
                                 contant: content,
                                 didApprove: didApprove)
        .environmentObject(manager)
        .environment(\.managedObjectContext, manager.container.viewContext)
        .onAppear { content.setButtonConfig = setButtonConfig }
    }
    
    private func setButtonConfig(enable: Bool) {
        withAnimation(.easeInOut) {
            buttonConfig.set(.defulat(state: enable ? .enabled : .disabled,
                                      dimantions: .full))
        }
    }
}

//#Preview {
//    ProfileCreationView()
//}
