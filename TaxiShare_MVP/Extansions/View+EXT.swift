//
//  View+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 19/08/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
