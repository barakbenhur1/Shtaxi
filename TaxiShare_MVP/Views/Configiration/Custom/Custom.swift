//
//  Custom.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct Custom {
    private let custom: CustomProvider = CustomProvider()
    static var shared: CustomProvider = Custom().custom
}

struct CustomProvider {
    internal init(){}
    lazy var color: ColorItem = ColorItem()
    lazy var font: FontItem = FontItem()
}

internal struct ColorItem {
    let tBlue: Color = Color(hex: "#0C8CE9")
    let tGray: Color = Color(hex: "#ACACAC")
    let lightText: Color = Color(hex: "#FAFAFA")
    let darkText: Color = Color(hex: "#131313")
    let infoText: Color = Color(hex: "#7B7B7B")
    let progressStart: Color = Color(hex: "#6CC1FF")
    let progressEnd: Color = Color(hex: "#0094FF")
    let inputFiled: Color = Color(hex: "#727272")
    let tYellow: Color = Color(hex: "#FFC100")
    let white: Color = .white
    let black: Color = .black
    let gray: Color = .gray
    let red: Color = .red
    let yellow: Color = .yellow
    let clear: Color = .clear
}

internal struct FontItem {
    private static let notoHebrew = "NotoSansHebrew-Thin"
    private static let regular = "_Regular"
    private static let bold = "_Bold"
    private static let semibold = "_SemiBold"
    
    let title: Font = .custom("\(notoHebrew)\(bold)", size: 32)
    let textHuge: Font = .custom("\(notoHebrew)\(regular)", size: 36)
    let textHugeBold: Font = .custom("\(notoHebrew)\(bold)", size: 36)
    let textBig: Font = .custom("\(notoHebrew)\(regular)", size: 20)
    let textBigBold: Font = .custom("\(notoHebrew)\(bold)", size: 20)
    let button: Font = .custom("\(notoHebrew)\(semibold)", size: 12)
    let textMedium: Font = .custom("\(notoHebrew)\(regular)", size: 16)
    let textMediumBold: Font = .custom("\(notoHebrew)\(bold)", size: 16)
    let textSmall: Font = .custom("\(notoHebrew)\(regular)", size: 12)
    let none: Font = .custom("", size: 0)
}
