//
//  TButtonConfig.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation
import SwiftUI

// MARK: TButtonDimantions
internal enum TButtonDimantions: Hashable {
    case none, full, hagging
}

// MARK: Border
internal struct Border: Hashable {
    let width: CGFloat
    let color: Color
}

// MARK: TButtonConfigRawValue
internal struct TButtonConfigRawValue: Hashable {
    let dimantions: TButtonDimantions
    let font: Font
    let forgroundColor: Color
    let backroundColor: Color
    let cornerRadius: CGFloat
    let enabled: Bool
    let border: Border
}

// MARK: TButtonConfig
enum TButtonConfig: Hashable {
    case none,
         designed(dimantions: TButtonDimantions,
                  enabled: Bool),
         critical(dimantions: TButtonDimantions,
                  enabled: Bool),
         selectebale(selected: Bool,
                     dimantions: TButtonDimantions,
                     enabled: Bool),
         regular(bold: Bool,
                 dimantions: TButtonDimantions,
                 enabled: Bool),
         custom(dimantions: TButtonDimantions,
                font: Font,
                forgroundColor: Color,
                backroundColor: Color,
                cornerRadius: CGFloat,
                enabled: Bool,
                border: Border)
}

extension TButtonConfig: RawRepresentable {
    internal typealias RawValue = TButtonConfigRawValue
    
    var font: Font { return rawValue.font }
    var enabled: Bool { return rawValue.enabled }
    var forgroundColor: Color { return rawValue.forgroundColor }
    var backroundColor: Color { return rawValue.backroundColor }
    var cornerRadius: CGFloat { return rawValue.cornerRadius }
    var dimantions: TButtonDimantions { return rawValue.dimantions }
    var border: Border { return rawValue.border }
    
    init?(rawValue: TButtonConfigRawValue) {
        self = .none
        switch rawValue {
        case .init(dimantions: rawValue.dimantions,
                   font: rawValue.font,
                   forgroundColor: rawValue.enabled ? .black : .darkText,
                   backroundColor: .clear,
                   cornerRadius: 0,
                   enabled: rawValue.enabled,
                   border: .init(width: 0,
                                 color: .clear)):
            
            if rawValue.font == .textMedium || rawValue.font == .textMediumBold {
                self = .regular(bold: rawValue.font == .textMediumBold,
                                dimantions: rawValue.dimantions,
                                enabled: rawValue.enabled)
            }
            else {
                self = .custom(dimantions: rawValue.dimantions,
                               font: rawValue.font,
                               forgroundColor: rawValue.forgroundColor,
                               backroundColor: rawValue.backroundColor,
                               cornerRadius: rawValue.cornerRadius,
                               enabled: rawValue.enabled,
                               border: rawValue.border)
            }
            
            return
            
        case .init(dimantions: rawValue.dimantions,
                   font: .button,
                   forgroundColor: rawValue.enabled ?.lightText : .darkText,
                   backroundColor: rawValue.enabled ? .tBlue : .tGray,
                   cornerRadius: 149,
                   enabled: rawValue.enabled,
                   border: .init(width: 0,
                                 color: .clear)):
            
            self = .designed(dimantions: rawValue.dimantions,
                             enabled: rawValue.enabled)
            return
            
        case .init(dimantions: rawValue.dimantions,
                   font: rawValue.font,
                   forgroundColor: rawValue.enabled ? .inputFiled : .darkText,
                   backroundColor: .white,
                   cornerRadius: 149,
                   enabled: rawValue.enabled,
                   border: .init(width: 1,
                                 color: rawValue.enabled ? rawValue.font == .textMediumBold ? .tBlue : .darkText : .darkText)):
            
            if rawValue.font == .textMedium || rawValue.font == .textMediumBold {
                self = .selectebale(selected: rawValue.font == .textMediumBold,
                                    dimantions: rawValue.dimantions,
                                    enabled: rawValue.enabled)
            }
            else {
                self = .custom(dimantions: rawValue.dimantions,
                               font: rawValue.font,
                               forgroundColor: rawValue.forgroundColor,
                               backroundColor: rawValue.backroundColor,
                               cornerRadius: rawValue.cornerRadius,
                               enabled: rawValue.enabled,
                               border: rawValue.border)
            }
            
            return
            
        case .init(dimantions: rawValue.dimantions,
                   font: .textCritical,
                   forgroundColor: rawValue.enabled ? .red : .darkText,
                   backroundColor: .clear,
                   cornerRadius: 0,
                   enabled: rawValue.enabled,
                   border: .init(width: 0,
                                 color: .clear)):
            
            self = .critical(dimantions: rawValue.dimantions,
                             enabled: rawValue.enabled)
            return
            
        case .init(dimantions: rawValue.dimantions,
                   font: rawValue.font,
                   forgroundColor: rawValue.forgroundColor,
                   backroundColor: rawValue.backroundColor,
                   cornerRadius: rawValue.cornerRadius,
                   enabled: rawValue.enabled,
                   border: rawValue.border):
            
            self = .custom(dimantions: rawValue.dimantions,
                           font: rawValue.font,
                           forgroundColor: rawValue.forgroundColor,
                           backroundColor: rawValue.backroundColor,
                           cornerRadius: rawValue.cornerRadius,
                           enabled: rawValue.enabled,
                           border: rawValue.border)
            
            return
            
        default:
            self = .none
            
            return
        }
    }
    
    var rawValue: TButtonConfigRawValue {
        switch self {
        case .none:
            return .init(dimantions: .none,
                         font: .none,
                         forgroundColor: .clear,
                         backroundColor: .clear,
                         cornerRadius: 0,
                         enabled: false,
                         border: .init(width: 0,
                                       color: .clear))
            
        case .regular(let bold, let dimantions, let enabled):
            return .init(dimantions: dimantions,
                         font: bold ? .textMediumBold : .textMedium,
                         forgroundColor: enabled ? .black : .darkText,
                         backroundColor: .clear,
                         cornerRadius: 0,
                         enabled: enabled,
                         border: .init(width: 0,
                                       color: .clear))
            
        case .designed(let dimantions, let enabled):
            return .init(dimantions: dimantions,
                         font: .button,
                         forgroundColor: enabled ?.lightText : .darkText,
                         backroundColor: enabled ? .tBlue : .tGray,
                         cornerRadius: 149,
                         enabled: enabled,
                         border: .init(width: 0,
                                       color: .clear))
            
        case .selectebale(let selected, let dimantions, let enabled):
            return .init(dimantions: dimantions,
                         font: selected ? .textMediumBold: .textMedium,
                         forgroundColor: enabled ? selected ? .tBlue : .inputFiled : .darkText,
                         backroundColor: .white,
                         cornerRadius: 149,
                         enabled: enabled,
                         border: .init(width: 1,
                                       color: enabled ? selected ? .tBlue : .darkText : .darkText))
            
        case .critical(let dimantions, let enabled):
            return .init(dimantions: dimantions,
                         font: .textCritical,
                         forgroundColor: enabled ? .red : .darkText,
                         backroundColor: .clear,
                         cornerRadius: 0,
                         enabled: enabled,
                         border: .init(width: 0,
                                       color: .clear))
            
        case .custom(let dimantions, let font, let forgroundColor, let backroundColor, let cornerRadius, let enabled, let border):
            return .init(dimantions: dimantions,
                         font: font,
                         forgroundColor: forgroundColor,
                         backroundColor: backroundColor,
                         cornerRadius: cornerRadius,
                         enabled: enabled,
                         border: border)
        }
    }
}
