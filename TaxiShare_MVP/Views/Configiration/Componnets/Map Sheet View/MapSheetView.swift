//
//  MapSheetView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI
import Combine

struct MapSheetView: View {
    @State private var buttonConfigManager = TButtonConfigManager(config: .designed(dimantions: .full,
                                                                                    enabled: false,
                                                                                    bold: true,
                                                                                    cornerRadius: 8))
    @State private var fromItem: DestanationSearch? = nil
    @State private var toItem: DestanationSearch? = nil
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var number: Int = -1
    @State private var selectedIndex = -1
    @State private var filters: [String] = []
    @State private var filterOptions: [[FilterCell]] = [
        [
            .init(image: "price",
                  text: "מחיר".localized()),
            .init(image: "mFrindes",
                  text: "חברים משותפים".localized())
        ],
        [
            .init(image: "time",
                  text: "שעת איסוף".localized()),
            .init(image: "rating",
                  text: "דירוג".localized())
        ]
    ]
    
    private let buttons: [String] = {
        return [
            "4",
            "3",
            "2"
        ]
    }()
    
    let showDestenationSearchView: (DestanationSearchView?) -> ()
    let trip: (_ from: DestanationSearch, _ to: DestanationSearch, _ number: Int, _ filters: [String]) -> ()
    
    private func getIndexFor(cell: FilterCell) -> (Int, Int)? {
        for i in 0..<filterOptions.count {
            for j in 0..<filterOptions[i].count {
                if cell == filterOptions[i][j] { return (i, j) }
            }
        }
        
        return nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    swap(o1: &fromItem, o2: &toItem)
                    swap(o1: &from, o2: &to)
                } label: {
                    Image("swap")
                }
                .frame(height: 44)
                .frame(width: 44)
                .padding(.trailing, 32)
                
                VStack(spacing: 24) {
                    textField(image: "location",
                              placeHolder: "מאיפה יוצאים?".localized(),
                              text: $from) {
                        from = ""
                        fromItem = nil
                        configButton(enabled: false)
                    }
                              .onTapGesture {
                                  let text = fromItem != nil ? "\(fromItem!.city) \(fromItem!.street)" : ""
                                  let view = DestanationSearchView(image: "location",
                                                                   placeHolder: "מאיפה יוצאים?".localized(),
                                                                   text: text) { serach in
                                      showDestenationSearchView(nil)
                                      guard let serach else { return }
                                      fromItem = serach
                                      let value = "\(serach.city) - \(serach.street)"
                                      from = value
                                      configButton(enabled: !from.isEmpty && !to.isEmpty && number > -1 )
                                  }
                                  
                                  showDestenationSearchView(view)
                              }
                    
                    textField(image: "flag",
                              placeHolder: "לאן נוסעים?".localized(),
                              text: $to) {
                        to = ""
                        toItem = nil
                        configButton(enabled: false)
                    }
                              .onTapGesture {
                                  let text = toItem != nil ? "\(toItem!.city) \(toItem!.street)" : ""
                                  let view = DestanationSearchView(image: "flag",
                                                                   placeHolder: "לאן נוסעים?".localized(),
                                                                   text: text) { serach in
                                      showDestenationSearchView(nil)
                                      guard let serach else { return }
                                      toItem = serach
                                      let value = "\(serach.city) - \(serach.street)"
                                      to = value
                                      configButton(enabled: !from.isEmpty && !to.isEmpty && number > -1 )
                                  }
                                  
                                  showDestenationSearchView(view)
                              }
                }
            }
            .padding(.bottom, 24)
            
            HStack {
                Spacer()
                RightText(text: "כמה תהיו?".localized(),
                          font: .textMediumBold)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 9) {
                Spacer()
                
                ForEach(buttons, id: \.self) { button in
                    if let index = buttons.firstIndex(of: button) {
                        selectedButton(text: button,
                                       selected: selectedIndex == index) {
                            selectedIndex = index
                            number = Int(button)!
                            configButton(enabled: !from.isEmpty && !to.isEmpty && number > -1 )
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            
            HStack {
                Spacer()
                RightText(text: "סינון תוצאות לפי".localized(),
                          font: .textMediumBold)
            }
            .padding(.bottom, 8)
            
            HStack {
                Spacer()
                TableView(diraction: .vertical, 
                          items: $filterOptions) { item in
                    guard let axis = getIndexFor(cell: item) else { return }
                    filterOptions[axis.0][axis.1].selected.toggle()
                    if filterOptions[axis.0][axis.1].selected {
                        filters.append(filterOptions[axis.0][axis.1].text)
                    }
                    else {
                        guard let at = filters.firstIndex(of: filterOptions[axis.0][axis.1].text) else { return }
                        filters.remove(at: at)
                    }
                }
                .frame(height: 92)
            }
            .padding(.bottom, 32)
            
            TButton(text: "חיפוש הצעות נסיעה".localized(),
                    config: buttonConfigManager.config) {
                guard let fromItem, let toItem else { return }
                self.trip(fromItem, toItem, number, filters)
                
                self.fromItem = nil
                self.toItem = nil
                self.from = ""
                self.to = ""
                self.number = -1
                self.selectedIndex = -1
                self.filters = []
                self.filterOptions = [
                    [
                        .init(image: "price",
                              text: "מחיר".localized()),
                        .init(image: "mFrindes",
                              text: "חברים משותפים".localized())
                    ],
                    [
                        .init(image: "time",
                              text: "שעת איסוף".localized()),
                        .init(image: "rating",
                              text: "דירוג".localized())
                    ]
                ]
            }
        }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .padding(.bottom, 40)
    }
    
    private func swap<T>(o1: inout T, o2: inout T) {
        let temp = o1
        o1 = o2
        o2 = temp
    }
    
    private func configButton(enabled: Bool) {
        withAnimation(.smooth) {
            buttonConfigManager.config = .designed(dimantions: .full,
                                                   enabled: enabled, 
                                                   bold: true,
                                                   cornerRadius: 8)
        }
    }
    
    @ViewBuilder private func selectedButton(text: String, selected: Bool, tap: @escaping () -> ()) -> some View {
        Text(text)
            .foregroundStyle(selected ? Color.tBlue : Color.gBlack)
            .font(.textMedium)
            .onTapGesture { tap() }
            .cornerRadius(18, corners: .allCorners)
            .frame(height: 36)
            .frame(width: 51)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(selected ? Color.tBlue : Color.gBlack,
                            lineWidth: 1)
            )
    }
    
    @ViewBuilder private func textField(image: String, placeHolder: String, text: Binding<String>, clear: @escaping () -> ()) -> some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .frame(width: 24)
                .padding(.leading, 24)
                .padding(.trailing, 4)
            
            if !text.wrappedValue.isEmpty {
                Button {
                    clear()
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .foregroundColor(.secondary)
                .padding(.trailing, 4)
                .frame(height: 18)
                .frame(width: 18)
            }
            
            TextField(placeHolder,
                      text: text)
            .focusable(false)
            .font(.textMedium)
            .multilineTextAlignment(.trailing)
            .autocorrectionDisabled()
            .padding(.trailing, 24)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.infoText,
                        lineWidth: 1)
        )
    }
}

//#Preview {
//    MapSheetView { _ in
//        
//    }
//}
