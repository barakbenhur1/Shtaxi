//
//  OnboardingProgressbleManegerView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/08/2024.
//

import SwiftUI

struct OnboardingProgressbleManagerView: ProfileUpdater {
    @EnvironmentObject private var manager: CoreDataManager
    @EnvironmentObject private var vm: OnboardingViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
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
                                                                      content: .init(vm: vm, 
                                                                                     text: value,
                                                                                      complition: setButtonConfig),
                                                                      onAppear: setScreen)
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
            case .birthdate(let value):
                OnboardingProgressbleHandelerView<OnboardingBirthdateView>(value: $progreesSatge,
                                                                            total: screens.count,
                                                                           content: .init(vm: vm, 
                                                                                          date: value,
                                                                                           complition: setButtonConfig),
                                                                           onAppear: setScreen)
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
            case .gender(let value):
                OnboardingProgressbleHandelerView<OnboardingGenderView>(value: $progreesSatge,
                                                                         total: screens.count,
                                                                        content: .init(vm: vm,
                                                                                       selectedIndex: value,
                                                                                        complition: setButtonConfig,
                                                                                        otherAction: otherAction),
                                                                        onAppear: setScreen)
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
            case .rules:
                OnboardingProgressbleHandelerView<OnboardingRulesView>(value: $progreesSatge,
                                                                        total: screens.count,
                                                                       content: .init(vm: vm, 
                                                                                      onAppear: noActionNeeded),
                                                                       onAppear: setScreen)
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
            }
        }
        .onAppear {
            onAppear(self)
        }
    }
    
    func preformAction(manager: CoreDataManager, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        holder.value?.preformAction(manager: manager,
                                    profile: profile,
                                    complete: complete)
    }
}

//#Preview {
//    OnboardingProgressbleManegerView()
//}
