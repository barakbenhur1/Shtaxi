//
//  TButtonConfigManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 07/09/2024.
//

import SwiftUI

class TButtonConfigManager: ObservableObject {
    @Published var buttonConfig: TButtonConfig
    
    init(buttonConfig: TButtonConfig) {
        self.buttonConfig = buttonConfig
    }
}
