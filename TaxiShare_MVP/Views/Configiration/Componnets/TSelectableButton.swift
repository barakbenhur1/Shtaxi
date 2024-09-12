//
//  TSelectableButton.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

struct TSelectableButton: View {
    private let title: String
    @Binding private var manger: TButtonConfigManager
    private let isSelected: () -> ()
    
    init(text: String, selected: Bool, isSelected: @escaping () -> Void) {
        _manger = .constant(.init(config: .selectebale(selected: selected,
                                                                   dimantions: .full,
                                                                   enabled: true)))
        self.title = text
        self.isSelected = isSelected
    }
    
    var body: some View {
        TButton(text: title,
                config: manger.config,
                didTap: isSelected)
    }
}

//#Preview {
//    TSelectableButton(text: "sdfsdfsd",
//                      config: .constant(.init(rawValue: .init(state: .selectebale(selected: false),
//                                                              font: .title,
//                                                              dimantions: .full))!)) {
//        
//    }
//}
