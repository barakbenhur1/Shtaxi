//
//  TButtonConfig.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation
import SwiftUI

enum TButtonDimantions {
    case none, full, hagging
}

enum TButtonConfig: Hashable {
    case none, regular(bold: Bool, dimantions: TButtonDimantions, enabled: Bool), designed(dimantions: TButtonDimantions, enabled: Bool), selectebale(selected: Bool, dimantions: TButtonDimantions, enabled: Bool), critical(dimantions: TButtonDimantions, enabled: Bool)
    
    
    var font: Font {
        switch self {
        case .regular(let bold, _, _):
            return bold ? .textMediumBold : .textMedium
        case .designed:
            return .button
        case .selectebale(let selected, _, _):
            return selected ? .textMediumBold: .textMedium
        case .critical:
            return .textCritical
        case .none:
            return .none
        }
    }
    
    var enabled: Bool {
        switch self {
        case .none:
            return false
        case .regular(_, _, let enabled):
            return enabled
        case .designed(_, let enabled):
            return enabled
        case .selectebale(_, _, let enabled):
            return enabled
        case .critical(_, let enabled):
            return enabled
        }
    }
    
    var forgroundColor: Color {
        switch self {
        case .regular(_, _, let enabled):
            return enabled ? .black : .darkText
        case .designed(_, let enabled):
            return  enabled ?.lightText : .darkText
        case .critical(_, let enabled):
            return enabled ? .red : .darkText
        case .selectebale(let selected, _, let enabled):
            return enabled ? selected ? .tBlue : .inputFiled : .darkText
        case .none:
            return .clear
        }
    }
    
    var backroundColor: Color {
        switch self {
        case .regular:
            return .clear
        case .designed(_, let enblaed):
            return enblaed ? .tBlue : .tGray
        case .critical:
            return .clear
        case .selectebale:
            return .white
        case .none:
            return .clear
        }
    }
    
    var dimantions: TButtonDimantions {
        switch self {
        case .none:
            return .none
        case .regular(_, let dimantions, _):
            return dimantions
        case .designed(let dimantions, _):
            return dimantions
        case .selectebale(_, let dimantions,_):
            return dimantions
        case .critical(let dimantions, _):
            return dimantions
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .none, .critical, .regular:
            return 0
        case .designed, .selectebale:
            return 149
        }
    }
}
