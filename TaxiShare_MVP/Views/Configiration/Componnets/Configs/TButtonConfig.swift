//
//  TButtonConfig.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation

enum TButtonConfig: Hashable {
    case none, defulat(state: TButtonState, dimantions: TButtonDimantions)
}

extension TButtonConfig {
    mutating func set(_ value: TButtonConfig) {
        self = value
    }
}

extension TButtonConfig: RawRepresentable {
    typealias RawValue = TButtonConfigItem
    
    init?(rawValue: TButtonConfigItem) {
        let states: [TButtonState] = [.regular(bold: true), .regular(bold: false), .enabled, .disabled, .critical, .none]
        let dimantions: [TButtonDimantions] = [.full, .hagging, .none]
        
        self = .none
        
        states.forEach { state in
            dimantions.forEach { dimantion in
                switch rawValue {
                case .init(state: state, font: state.font(), cornerRadius: 149, dimantions: dimantion):
                    return self = .defulat(state: state, dimantions: dimantion)
                default:
                    return self = .none
                }
            }
        }
    }
    
    var rawValue: TButtonConfigItem {
        switch self {
        case .defulat(let state, let dimantions):
            return .init(state: state, font: Custom.shared.font.button, cornerRadius: 149, dimantions: dimantions)
        case .none:
            return .init(state: .none, font: Custom.shared.font.none, dimantions: .none)
        }
    }
}
