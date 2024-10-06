//
//  ButtonWithShadow.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 05/10/2024.
//

import SwiftUI

struct ButtonWithShadow: View {
    let image: String
    let didSelect: () -> ()
    
    var body: some View {
        Button {
            didSelect()
        } label: {
            Image(image)
        }
        .frame(height: 52)
        .frame(width: 52)
        .shadow(radius: 3,
                y: 3)
    }
}
