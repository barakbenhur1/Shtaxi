//
//  TButtonConfigItem.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation
import SwiftUI

enum TButtonState: Hashable {
    case regular(bold: Bool), enabled, disabled, selectebale(selected: Bool), critical, none
    
    func font() -> Font {
        switch self {
        case .regular(let bold):
            return bold ? Custom.shared.font.textHugeBold : Custom.shared.font.textHuge
        case .enabled:
            return Custom.shared.font.button
        case .disabled:
            return Custom.shared.font.button
        case .selectebale(let selected):
            return selected ? Custom.shared.font.textMediumBold: Custom.shared.font.textMedium
        case .critical:
            return Custom.shared.font.textHugeBold
        case .none:
            return Custom.shared.font.none
        }
    }
    
    func isDisabled() -> Bool {
        switch self {
        case .regular:
            return false
        case .enabled:
            return false
        case .disabled:
            return true
        case .critical:
            return false
        case .selectebale:
            return false
        case .none:
            return false
        }
    }
    
    func getForgroundColor() -> Color {
        switch self {
        case .regular:
            return Custom.shared.color.black
        case .enabled:
            return Custom.shared.color.lightText
        case .disabled:
            return Custom.shared.color.darkText
        case .critical:
            return Custom.shared.color.red
        case .selectebale(let selected):
            return selected ? Custom.shared.color.tBlue : Custom.shared.color.inputFiled
        case .none:
            return Custom.shared.color.clear
        }
    }
    
    func getBackroundColor() -> Color {
        switch self {
        case .regular:
            return Custom.shared.color.clear
        case .enabled:
            return Custom.shared.color.tBlue
        case .disabled:
            return Custom.shared.color.tGray
        case .critical:
            return Custom.shared.color.clear
        case .selectebale(_):
            return Custom.shared.color.white
        case .none:
            return Custom.shared.color.clear
        }
    }
}

enum TButtonDimantions {
    case none, full, hagging
}

struct TButtonConfigItem: Equatable {
    let state: TButtonState
    let font: Font
    var cornerRadius: CGFloat = 0
    let dimantions: TButtonDimantions
}
