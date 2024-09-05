//
//  TButtonParams.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import Foundation

struct TButtonParams: Identifiable, Hashable {
    let id = UUID()
    let title: String
    var config: TButtonConfig
}
