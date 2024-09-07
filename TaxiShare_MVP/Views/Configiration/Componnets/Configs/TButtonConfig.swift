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
                 enabled: Bool)
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
        let states: [Bool] = [false, true]
        let dimantionsArry: [TButtonDimantions] = [.full, .hagging, .none]
        
        self = .none
        
        for state in states {
            for dimantions in dimantionsArry {
                switch rawValue {
                case .init(dimantions: dimantions,
                           font: rawValue.font,
                           forgroundColor: state ? .black : .darkText,
                           backroundColor: .clear,
                           cornerRadius: 0,
                           enabled: state,
                           border: .init(width: 0,
                                         color: .clear)):
                    
                    self = .regular(bold: rawValue.font == .textMediumBold,
                                    dimantions: dimantions,
                                    enabled: state)
                    return
                    
                case .init(dimantions: dimantions,
                           font: .button,
                           forgroundColor: state ?.lightText : .darkText,
                           backroundColor: state ? .tBlue : .tGray,
                           cornerRadius: 149,
                           enabled: state,
                           border: .init(width: 0,
                                         color: .clear)):
                    
                    self = .designed(dimantions: dimantions,
                                     enabled: state)
                    return
                    
                case .init(dimantions: dimantions,
                           font: rawValue.font,
                           forgroundColor: state ? .inputFiled : .darkText,
                           backroundColor: .white,
                           cornerRadius: 149,
                           enabled: state,
                           border: .init(width: 1,
                                         color: state ? rawValue.font == .textMediumBold ? .tBlue : .darkText : .darkText)):
                    
                    self = .selectebale(selected: rawValue.font == .textMediumBold,
                                        dimantions: dimantions,
                                        enabled: state)
                    return
                    
                case .init(dimantions: dimantions,
                           font: .textCritical,
                           forgroundColor: state ? .red : .darkText,
                           backroundColor: .clear,
                           cornerRadius: 0,
                           enabled: state,
                           border: .init(width: 0,
                                         color: .clear)):
                    
                    self = .critical(dimantions: dimantions,
                                     enabled: state)
                    return
                    
                default:
                    self = .none
                    
                    return
                }
            }
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
        }
    }
}
