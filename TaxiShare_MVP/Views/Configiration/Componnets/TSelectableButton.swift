//
//  TSelectableButton.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

struct TSelectableButton: View {
    @Binding var params: TButtonParams
    let isSelected: () -> ()
    
    init(text: String, selected: Bool, isSelected: @escaping () -> Void) {
        _params = Binding(get: {
            return .init(title: text,
                         config: .selectebale(selected: selected,
                                              dimantions: .full,
                                              enabled: true))
        }, set: {_ in })
        self.isSelected = isSelected
    }
    
    var body: some View {
        TButton(text: params.title,
                config: params.config) {
            isSelected()
        }
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
