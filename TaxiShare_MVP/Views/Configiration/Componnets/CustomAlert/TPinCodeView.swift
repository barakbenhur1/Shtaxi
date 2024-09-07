//
//  PinCideView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI
import Combine

struct TPinCodeView: View {
    enum PinFiled: Int, Hashable {
        case one, two, three, four, five, six
    }
    
    @Binding var error: Bool
    @State private var pinCodeList: [String]
    @FocusState private var focusedField: PinFiled?
    let didDone: ([String]) -> ()
    
    let number: Int
    
    init(error: Binding<Bool>, didDone: @escaping ([String]) -> Void) {
        _error = error
        self.number = 6
        self.didDone = didDone
        self.pinCodeList = [String](repeating: "", count: number)
    }
    
    var body: some View {
        HStack(spacing: 14.8) {
            ForEach(0..<number, id: \.self) { current in
                PinCodeItemView(error: $error) { value in
                    guard value else { return }
                    focusedField = PinFiled(rawValue: current)!
                } didType: { text in
                    
                    if !pinCodeList[current].isEmpty && text.isEmpty {
                        if focusedField != .one {
                            if focusedField == .six || pinCodeList[current + 1].isEmpty {
                                focusedField = PinFiled(rawValue: current - 1)!
                            }
                        }
                    }
                    else if focusedField != .six && current < number - 1 {
                        if !text.isEmpty {
                            if pinCodeList[current + 1].isEmpty {
                                focusedField = PinFiled(rawValue: current + 1)!
                            }
                        }
                    }
                    
                    pinCodeList[current] = text
                    didDone(pinCodeList)
                }
                .focused($focusedField, equals: PinFiled(rawValue: current)!)
            }
        }
        .onAppear {
            self.focusedField = .one
        }
    }
}

struct PinCodeItemView: View {
    @State var text: String = ""
    @Binding var error: Bool
    let isFocused: (Bool) -> ()
    let didType: (String) -> ()
    
    var body: some View{
        VStack {
            TTextFieldView(label: "*",
                           text: $text,
                           textColor: error ? .red : .black,
                           keyboardType: .numberPad,
                           textAlignment: .center,
                           isFocused: { value in
                isFocused(value)
            })
            .padding(.top, 6)
            .onReceive(Just(text)) { _ in
                text.limitText(1)
                didType(text)
            }
            
            ZStack { error ? Color.red : Color.black }
            .frame(height: 1)
        }
    }
}

//#Preview {
//    TPinCodeView { _ in
//
//    }
//}
