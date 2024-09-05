//
//  TLogo.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct TLogo<S: Shape>: View {
    let shape: S
    let size: CGFloat
   
    var body: some View {
       Image("logo")
            .resizable()
            .clipShape(shape)
            .frame(width: size)
            .frame(height: size)
    }
}

//#Preview {
//    TLogo(size: 64)
//}
