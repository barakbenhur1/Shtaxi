//
//  OnboardingNameView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI
import Combine

struct OnboardingNameView<VM: OnboardringViewModel>: OnboardingProgress {
    @State internal var holder = Holder<String>()
    
    @ObservedObject internal var vm: VM
    @State internal var text: String
    internal let onAppear: (() -> ())? = nil
    internal let noActionNeeded: (() -> ())? = nil
    internal let complition: ((_ enable: Bool) -> ())?
    internal let otherAction: (() -> ())? = nil
    
    enum NameFiled: Int, Hashable {
        case name
    }
    
    @FocusState private var focusedField: NameFiled?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RightText(text: "מה השם שלך?",
                          font: .title)
            }
            .padding(.bottom, 20)
            
            TTextFieldView(label: "הכנסת שם פרטי",
                           text: $text,
                           textColor: .black,
                           keyboardType: .default,
                           textAlignment: .trailing) { _ in }
                .onReceive(Just(text)) { _ in
                    holder.value = text
                    complition?(!text.isEmpty)
                }
                .focused($focusedField, equals: .name)
                .padding(.trailing, 24)
            
            ZStack { Color.black }
            .frame(height: 1)
            .padding(.bottom, 20)
            
            Text("Lorem ipsum dolor sit amet consectetur. Pulvinar sed in dui auctor imperdiet posuere bibendum. Diam sit sed semper.")
                .multilineTextAlignment(.center)
                .font(.textSmall)
                .foregroundStyle(Color.infoText)
        }
        .onAppear {
            focusedField = .name
        }
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        guard let profile else { return complete(false) }
        guard let name = holder.value else { return complete(false) }
        vm.update(profile: profile,
                  updateBody: .init(name: name)) {
            manager.set(profile: profile,
                        name: name)
            return complete(true)
        } error: { error in
            print(error)
            return complete(false)
        }
    }
}

//#Preview {
//    OnboardingNameView { _ in
//        
//    }
//}
