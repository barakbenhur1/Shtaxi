//
//  SideMnue.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/06/2024.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing: Bool
    var title: AnyView? = nil
    let content: AnyView
    let edge: Edge = .leading
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Custom.shared.color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack() {
                    if let title {
                        title
                            .padding(.bottom, 10)
                    }
                    content
                }
                .padding(.top, 80)
                .transition(.move(edge: edge))
                .background(
                    Custom.shared.color.white
                )
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, 
                   value: isShowing)
    }
}
