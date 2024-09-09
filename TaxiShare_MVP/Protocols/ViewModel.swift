//
//  ViewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import SwiftUI

protocol ViewModel: ObservableObject {
    associatedtype UC: USeCase
    var useCases: UC { get }
    init()
}

extension ViewModel {
    var binding: Binding<Self> {
        return Binding<Self> {
            return self
        } set: { _ in }
    }
}
