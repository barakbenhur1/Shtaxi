//
//  Font+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 07/09/2024.
//

import SwiftUI

extension Font {
    // MARK: Font Name
    private static let notoHebrew = "NotoSansHebrew-Thin"
    
    // MARK: Font Modifires
    private static let regular = "_Regular"
    private static let bold = "_Bold"
    private static let semibold = "_SemiBold"
    
    // MARK: Fonts
    static let tTitle: Font = .custom("\(notoHebrew)\(bold)", size: 32)
    static let textHuge: Font = .custom("\(notoHebrew)\(regular)", size: 36)
    static let textHugeBold: Font = .custom("\(notoHebrew)\(bold)", size: 36)
    static let textBig: Font = .custom("\(notoHebrew)\(regular)", size: 20)
    static let textBigBold: Font = .custom("\(notoHebrew)\(bold)", size: 20)
    static let textCritical: Font = .custom("\(notoHebrew)\(bold)", size: 18)
    static let button: Font = .custom("\(notoHebrew)\(semibold)", size: 12)
    static let textMedium: Font = .custom("\(notoHebrew)\(regular)", size: 16)
    static let textMediumBold: Font = .custom("\(notoHebrew)\(bold)", size: 16)
    static let textSmall: Font = .custom("\(notoHebrew)\(regular)", size: 12)
    static let none: Font = .custom("", size: 0)
    
}
