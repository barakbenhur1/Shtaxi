//
//  SwiftUIView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 29/06/2024.
//

import SwiftUI

enum FieldType: Hashable {
    case slider, pick
}

enum Gender: CGFloat, Hashable {
    case all = 0, male = 1, female = 2
    
    var string: String {
        switch self {
        case .male:
            return "גבר"
        case .female:
            return "אישה".localized()
        case.all:
            return "הכל"
        }
    }
}

struct Filed: Identifiable {
    var id = UUID()
    var type: FieldType
    var title: String
    var values: [CGFloat]
}

struct FilterView: ViewWithTransition {
    let transitionAnimation: Bool
    
    private let fileds: [Filed] =
    [
        .init(type: .slider,
              title: "טווח גילאים",
              values: [14, 100]),
        
            .init(type: .slider,
                  title: "מרחק ק״מ",
                  values: [0, 30]),
        
            .init(type: .pick,
                  title: "מין",
                  values: [0, 1, 2]),
    ]
    
    @State private var values: [CGFloat] = [14, 0, 0]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("סינון")
                .font(.title2)
                .padding(.top, 20)
                .padding(.bottom, 30)
            VStack {
                ForEach(fileds, id: \.id) { item in
                    HStack(spacing: 20) {
                        if let index = fileds.firstIndex(where: { filed in return filed.id == item.id }) {
                            switch item.type {
                            case .slider:
                                SliderView(minimumValue: item.values.first!,
                                           maximumValue: item.values.last!,
                                           value: $values[index])
                            case .pick:
                                Menu {
                                    ForEach(item.values, id: \.self) { value in
                                        Button(action: {
                                            values[index] = value
                                        }, label: {
                                            Text(Gender(rawValue: value)!.string)
                                        })
                                    }
                                } label: {
                                    Text(Gender(rawValue: values[index])!.string)
                                        .font(.title2)
                                        .foregroundStyle(Custom.shared.color.black)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding(.top, 4)
                                .padding(.bottom, 4)
                                .padding(.leading, 12)
                                .padding(.trailing, 12)
                            }
                        }
                        
                        Text(item.title)
                    }
                    .padding(.all, 10)
                }
            }
            .onAppear {
                values = []
                for filed in fileds {
                    values.append(filed.values.first!)
                }
            }
        }
    }
}

#Preview {
    FilterView(transitionAnimation: false)
}
