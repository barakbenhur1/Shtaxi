//
//  SideMnue.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/06/2024.
//

import SwiftUI

struct SideMenu<Title: View, Content: View>: View {
    @Binding var isShowing: Bool
    var title: Title? = nil
    let content: Content
    let edge: Edge
    let spaceFromEdge: CGFloat = 140
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                let view = VStack {
                    if let title {
                        title
                            .padding(.bottom, 10)
                    }
                    content
                }
                    .padding(.top, 80)
                    .transition(.move(edge: edge))
                    .background(.white)
                
                switch edge {
                case .leading:
                    view
                        .padding(.trailing, spaceFromEdge)
                case .trailing:
                    view
                        .padding(.leading, spaceFromEdge)
                case .top:
                    view
                        .padding(.bottom, spaceFromEdge)
                case .bottom:
                    view
                        .padding(.top, spaceFromEdge)
                }
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
