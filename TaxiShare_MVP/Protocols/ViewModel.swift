//
//  ViewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import SwiftUI

protocol ViewModel: ObservableObject {
    var binding: Binding<Self> { get }
}
