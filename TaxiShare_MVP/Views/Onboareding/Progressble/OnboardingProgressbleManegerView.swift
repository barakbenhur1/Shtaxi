//
//  OnboardingProgressbleManegerView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/08/2024.
//

import SwiftUI

struct OnboardingProgressbleManagerView: ProfileUpdater {
    @EnvironmentObject private var vmProvider: ViewModelProvider
    
    @State private var holder = Holder<any ProfileUpdater>()
    let buttonText: String = ""
    let screens: [OnboardingProgressble]
    @Binding var progreesSatge: Int
    let onAppear: (any ProfileUpdater) -> ()
    let noActionNeeded: (() -> ())?
    let setButtonConfig: (Bool) -> ()
    let otherAction: () -> ()
    let didDone: (() -> ())? = nil
    
    private var setScreen: (any ProfileUpdater) -> () {
        return { screen in holder.value = screen }
    }
    
    var body: some View {
        ZStack {
            switch screens[progreesSatge] {
            case .name(let value):
                OnboardingProgressbleHandelerView<OnboardingNameView>(value: $progreesSatge,
                                                                       total: screens.count,
                                                                      content: .init(vm: vmProvider.viewModel(),
                                                                                     text: value,
                                                                                      complition: setButtonConfig),
                                                                      onAppear: setScreen)
            case .birthdate(let value):
                OnboardingProgressbleHandelerView<OnboardingBirthdateView>(value: $progreesSatge,
                                                                            total: screens.count,
                                                                           content: .init(vm: vmProvider.viewModel(),
                                                                                          date: value,
                                                                                           complition: setButtonConfig),
                                                                           onAppear: setScreen)
            case .gender(let value):
                OnboardingProgressbleHandelerView<OnboardingGenderView>(value: $progreesSatge,
                                                                         total: screens.count,
                                                                        content: .init(vm: vmProvider.viewModel(),
                                                                                       selectedIndex: value,
                                                                                        complition: setButtonConfig,
                                                                                        otherAction: otherAction),
                                                                        onAppear: setScreen)
            case .rules:
                OnboardingProgressbleHandelerView<OnboardingRulesView>(value: $progreesSatge,
                                                                        total: screens.count,
                                                                       content: .init(vm: vmProvider.viewModel(), 
                                                                                      onAppear: noActionNeeded),
                                                                       onAppear: setScreen)
            }
        }
        .onAppear {
            onAppear(self)
        }
    }
    
    func preformAction(profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        holder.value?.preformAction(profile: profile,
                                    complete: complete)
    }
}

//#Preview {
//    OnboardingProgressbleManegerView()
//}
