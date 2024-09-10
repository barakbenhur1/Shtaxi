//
//  TDateTextFiled.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI
import Combine

struct TDateTextFiled: View {
    enum DateFiled: Int, Hashable {
        case day, month, year
    }
    
    @State var day: String
    @State var month: String
    @State var year: String
    
    @Binding var error: Bool
    let didType: (String, String, String) -> ()
    
    @FocusState private var focusedField: DateFiled?
    
    var body: some View {
        HStack {
            TDateComponnet(label: "יום",
                           text: $day,
                           limit: 2,
                           error: $error) { text in
                if let d = Int(day), d > 31 {
                    _ = day.popLast()
                }
                if day.count == 2 {
                    guard focusedField == .day  else { return }
                    focusedField = .month
                }
                didType(day, month, year)
            }
                           .frame(maxWidth: 79)
                           .focused($focusedField, 
                                    equals: .day)
            separetor()
            TDateComponnet(label: "חודש",
                           text: $month,
                           limit: 2,
                           error: $error){ text in
                if let m = Int(month), m > 12 {
                    _ = month.popLast()
                }
                if month.count == 2 {
                    guard focusedField == .month  else { return }
                    focusedField = .year
                }
                else if month.isEmpty {
                    guard focusedField == .month  else { return }
                    focusedField = .day
                }
                didType(day, month, year)
            }
                           .frame(maxWidth: 79)
                           .focused($focusedField, 
                                    equals: .month)
            separetor()
            TDateComponnet(label: "שנה",
                           text: $year,
                           limit: 4,
                           error: $error) { text in
                if year.isEmpty {
                    guard focusedField == .year  else { return }
                    focusedField = .month
                }
                didType(day, month, year)
            }
                           .frame(maxWidth: 167)
                           .focused($focusedField, 
                                    equals: .year)
        }
        .frame(height: 52)
        .onAppear {
            self.focusedField = .day
        }
    }
    
    @ViewBuilder private func separetor() -> some View {
        Text("/")
            .font(.textMedium)
            .foregroundStyle(Color.inputFiled)
    }
}

struct TDateComponnet: View {
    let label: String
    @Binding var text: String
    let limit: Int
    @Binding var error: Bool
    let didType: (String) -> ()
    
    var body: some View {
        VStack {
            TTextFieldView(label: label,
                           text: $text,
                           textColor: error ? .red : .black,
                           keyboardType: .numberPad,
                           textAlignment: .center) { _ in }
                .onReceive(Just(text)) { _ in
                    text.limitText(limit)
                    didType(text)
                }
            ZStack { error ? Color.red : Color.black }
            .frame(height: 1)
        }
    }
}

//#Preview {
//    TDateTextFiled { day, month, year in
//        
//    }
//}
