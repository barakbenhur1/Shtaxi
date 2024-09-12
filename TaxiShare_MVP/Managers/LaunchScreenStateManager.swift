//
//  LaunchScreenStateManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 12/09/2024.
//

import Foundation

final class LaunchScreenStateManager: ObservableObject {
    enum LaunchScreenStep {
        case firstStep
        case secondStep
        case finished
    }
    
    @MainActor @Published private(set) var state: LaunchScreenStep = .firstStep
    @Published var sleep: CGFloat = 1
    
    @MainActor func dismiss() {
        Task {
            state = .secondStep
            
            try? await Task.sleep(for: Duration.seconds(sleep))
            
           state = .finished
        }
    }
}
