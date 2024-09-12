//
//  TButtonConfigManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 07/09/2024.
//

import SwiftUI

class TButtonConfigManager: ObservableObject {
    @Published var config: TButtonConfig
    
    init(config: TButtonConfig) {
        self.config = config
    }
}
