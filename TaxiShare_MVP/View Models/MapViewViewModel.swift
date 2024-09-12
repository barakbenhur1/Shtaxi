//
//  MapViewVM.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/06/2024.
//

import SwiftUI

final class MapViewViewModel: ViewModel {
    internal let useCases = MapUseCases(repo: MapRepositoryImpl(dataSource: MapDataSource()))
    
//    required init() {}
    
    @Published var isShowSheet: Bool = false
    @Published var startPositionValue: SearchCompletions? = .init(title: "start place", subTitle: "", location: nil)
    @Published var endPositionValue: SearchCompletions? = .init(title: "", subTitle: "", location: nil)
    @Published var sheetValue: Int? {
        didSet {
            isShowSheet = sheetValue != nil
        }
    }
}

