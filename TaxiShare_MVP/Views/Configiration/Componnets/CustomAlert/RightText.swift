//
//  RightText.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct RightText: View {
    let text: String
    let font: Font
    var body: some View {
        Text(text)
            .multilineTextAlignment(.trailing)
            .font(font)
            .fixedSize(horizontal: false, 
                       vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RightText(text: "Hello", font: .title)
}
