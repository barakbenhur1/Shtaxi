//
//  CollectionView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI

struct Cell: Hashable {
    let image: String
    let text: String
    var selected: Bool = false
}

struct TableView: View {
    @Binding var items: [[Cell]]
    let didTap: (Cell) -> ()

    var body: some View {
            VStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    row(items: item)
                }
            }
    }
    
    @ViewBuilder private func row(items: [Cell]) -> some View {
        HStack(spacing: 16) {
            Spacer()
            
            ForEach(items.reversed(), id: \.self) { item in
                ZStack {
                    HStack {
                        Image(item.image)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .frame(width: 24)
                        
                        Text(item.text)
                            .font(.text14)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(item.selected ? Color.tBlue : Color.gBlack)
                    }
                }
                .padding(.horizontal, 17)
                .padding(.vertical, 5)
                .frame(height: 36)
                .cornerRadius(36)
                .onTapGesture { didTap(item) }
                .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(item.selected ? Color.tBlue : Color.gBlack, lineWidth: 1)
                    )
            }
        }
    }
}
