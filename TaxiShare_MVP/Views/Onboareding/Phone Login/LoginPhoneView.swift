//
//  LoginPhoneView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/08/2024.
//

import SwiftUI
import Combine

enum ChangeField: Int, Hashable {
    case field
}

struct LoginPhoneView: View {
    @State var text: String = ""
    @FocusState private var focusedField: ChangeField?
    var beginFocused: Bool = false
    let didType: (_ phone: String) -> ()
    var onAppear: ((LoginPhoneView) -> ())? = nil
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RightText(text: "כניסה עם הנייד".localized(),
                          font: Custom.shared.font.title)
            }
            
            HStack {
                Image("phoneIcon")
                    .resizable()
                    .frame(height: 28)
                    .frame(width: 28)
                    .padding(.all)
                
                TTextFieldView(label: "הכנסת טלפון נייד".localized(),
                               text: $text,
                               textColor: Custom.shared.color.black,
                               keyboardType: .numberPad,
                               textAlignment: .trailing) { _ in }
                    .onReceive(Just(text)) { _ in
                        text.formatPhone()
                        text.limitText(11)
                        didType(text)
                    }
                    .focused($focusedField,
                             equals: .field)
            }
            .padding(.trailing, 24)
            ZStack {
                Custom.shared.color.black
            }
            .frame(height: 1)
            .padding(.bottom)
            
            Text("Lorem ipsum dolor sit amet consectetur. Pulvinar sed in dui auctor imperdiet posuere bibendum. Diam sit sed semper.".localized())
                .multilineTextAlignment(.center)
                .font(Custom.shared.font.textSmall)
                .foregroundStyle(Custom.shared.color.infoText)
            
            Spacer()
        }
        .onAppear {
            onAppear?(self)
            guard beginFocused else { return }
            focusedField = .field
        }
    }
}

#Preview {
    LoginPhoneView { _ in
        
    }
}
