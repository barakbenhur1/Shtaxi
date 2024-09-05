//
//  MapViewVM.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/06/2024.
//

import SwiftUI

@Observable class MapViewVM {
    var isShowSheet: Bool = false
    var startPositionValue: SearchCompletions? = .init(title: "start place", subTitle: "", location: nil)
    var endPositionValue: SearchCompletions? = .init(title: "", subTitle: "", location: nil)
    var sheetValue: Int? {
        didSet {
            isShowSheet = sheetValue != nil
        }
    }
}

