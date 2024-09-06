//
//  OnboardingGenderView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

struct OnboardingGenderView: OnboardingProgress {
    private let buttons: [String] = {
        return [
            "זכר",
            "נקבה",
            "אחר",
        ]
    }()
    
    @State internal var holder = Holder<Int>()
    
    @State internal var selectedIndex: Int?
    internal let noActionNeeded: (() -> ())? = nil
    internal let complition: ((_ enable: Bool) -> ())?
    internal let otherAction: (() -> ())?
    internal let vm = OnboardringViewModel()
    
    init(selectedIndex: Int?, complition: ((_ enable : Bool) -> ())?, otherAction: @escaping () -> ()) {
        self.selectedIndex = selectedIndex
        self.complition = complition
        self.otherAction = otherAction
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RightText(text: "מה המגדר שלך?",
                          font: Custom.shared.font.title)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                ForEach(buttons, id: \.self) { button in
                    if let index = buttons.firstIndex(of: button) {
                        TSelectableButton(text: button,
                                          selected: selectedIndex == index) {
                            selectedIndex = index
                            holder.value = index
                            complition?(true)
                        }
                                          .frame(height: 52)
                    }
                }
            }
            .padding(.bottom, 24)
            
            Button(action: {
                selectedIndex = -1
                holder.value = -1
                otherAction?()
            }, label: {
                Text("לא רוצה להגדיר כרגע".localized())
                    .foregroundStyle(Custom.shared.color.tBlue)
                    .font(Custom.shared.font.textMedium)
            })
            .padding(.bottom, 20)
            
            Text("Lorem ipsum dolor sit amet consectetur. Pulvinar sed in dui auctor imperdiet posuere bibendum. Diam sit sed semper.")
                .multilineTextAlignment(.center)
                .font(Custom.shared.font.textSmall)
                .foregroundStyle(Custom.shared.color.infoText)
        }
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        guard let profile else { return complete(false) }
        vm.update(profile: profile,
                  updateBody: .init(gender: holder.value)) {
            manager.set(profile: profile,
                        gender: holder.value)
            complete(true)
        } error: { error in
            print(error)
        }
    }
}

//#Preview {
//    OnboardingGenderView { _ in
//
//    } didSkip: {
//
//    }
//}
