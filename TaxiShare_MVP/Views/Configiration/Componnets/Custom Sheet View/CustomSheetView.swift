//
//  MapSheetView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/10/2024.
//

import SwiftUI

struct CustomSheetView<Content: View>: View {
    @State private var currentOffset: CGFloat = 0
    @State private var endOffset: CGFloat = 0
    @State private var startingOffset: CGFloat = 0
    @State private var offsetLimit: CGFloat = 0
    @State private var size: CGSize = .zero
    
    @Binding var open: Bool
    @ViewBuilder var content: () -> (Content)
    
    var body: some View {
        GeometryReader { proxy in
                VStack {
                    ZStack { Color.saperatorGrey }
                        .clipShape(RoundedRectangle(cornerRadius: 33))
                        .frame(height: 6)
                        .frame(width: 72)
                        .padding(.top, 24)
                        .padding(.bottom, 44)
                    
                    content()
                        .saveSize(in: $size)
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            startingOffset = UIScreen.main.bounds.height - proxy.size.height
                            offsetLimit = size.height + 10
                        }
                }
                .background(Color.white)
                .cornerRadius(44, corners: [.topLeft, .topRight])
                .frame(maxHeight: .infinity,
                       alignment: .bottom)
                .padding(.top, startingOffset)
                .offset(y: currentOffset)
                .offset(y: open ? 0 : offsetLimit)
                .animation(.spring, value: true)
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            let offset = endOffset + value.translation.height
                            if offset >= 0 && offset <= offsetLimit {
                                withAnimation(.spring) {
                                    currentOffset = value.translation.height
                                }
                            }
                            else if offset < 0 {
                                isOpen(true)
                            }
                            else if offset > offsetLimit {
                                isOpen(false)
                            }
                        }
                        .onEnded{ value in
                            if currentOffset <= -150 {
                                isOpen(true)
                            }
                            else if currentOffset >= 150 {
                                isOpen(false)
                            }
                            else {
                                isOpen(open)
                            }
                        }
                )
        }
    }
    
    private func isOpen(_ value: Bool) {
        withAnimation(.spring) {
            currentOffset = 0
            open = value
        }
    }
}

//#Preview {
//    CustomSheetView()
//}
