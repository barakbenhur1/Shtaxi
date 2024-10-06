//
//  CollectionView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI

struct FilterCell: Hashable {
    let image: String
    let text: String
    var selected: Bool = false
}

struct ProfileCell: Hashable {
    let image: String
//    let text: String
//    var selected: Bool = false
}

struct TableView<Cell: Hashable>: View {
    enum ScrollDircation {
        case vertical, horizontal
    }
    
    let diraction: ScrollDircation
    @Binding var items: [[Cell]]
    let didTap: (Cell) -> ()
    
    var body: some View {
        ScrollView(diraction == .vertical ? .vertical : .horizontal, showsIndicators: false) {
            ZStack {
                switch diraction {
                case .vertical:
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                        ForEach(items, id: \.self) { item in
                            row(items: item)
                        }
                    }
                case .horizontal:
                    LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                        ForEach(items, id: \.self) { item in
                            colum(items: item)
                        }
                    }
                }
            }
            .padding(.all, 1)
        }
        .onAppear { UIScrollView.appearance().bounces = false }
    }
    
    @ViewBuilder private func getCell(item: Cell) -> some View {
        switch Cell.self {
        case is FilterCell.Type:
            if let item = item as? FilterCell {
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
                .onTapGesture { didTap(item as! Cell) }
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(item.selected ? Color.tBlue : Color.gBlack, lineWidth: 1)
                )
            }
            
        case is ProfileCell.Type:
            if let item = item as? ProfileCell {
                ZStack {
                    HStack {
                        Image(item.image)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .frame(width: 24)
                        
//                        Text(item.text)
//                            .font(.text14)
//                            .multilineTextAlignment(.center)
//                            .foregroundStyle(item.selected ? Color.tBlue : Color.gBlack)
                    }
                }
                .padding(.horizontal, 17)
                .padding(.vertical, 5)
                .frame(height: 36)
                .cornerRadius(36)
                .onTapGesture { didTap(item as! Cell) }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 36)
//                        .stroke(item.selected ? Color.tBlue : Color.gBlack, lineWidth: 1)
//                )
            }
            
        default:
            ZStack {}
        }
    }
    
    @ViewBuilder private func colum(items: [Cell]) -> some View {
        VStack(spacing: 16) {
            ForEach(items.reversed(), id: \.self) { item in
                getCell(item: item)
            }
        }
    }
    
    @ViewBuilder private func row(items: [Cell]) -> some View {
        HStack(spacing: 16) {
            Spacer()
            ForEach(items.reversed(), id: \.self) { item in
                getCell(item: item)
            }
        }
    }
}
