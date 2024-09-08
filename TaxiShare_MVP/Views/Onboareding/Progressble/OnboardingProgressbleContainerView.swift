//
//  OnboardingProgressbleBaseView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/08/2024.
//

import SwiftUI

struct OnboardingProgressbleContainerView: View, ProfileHandeler {
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
    @EnvironmentObject private var vm: OnboardingViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject private var manager: CoreDataManager
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State internal var holder = Holder<any ProfileUpdater>()
    @State internal var buttonEnabled: Bool = false
    @State internal var externalActionLoading: Bool? = false
    @State private var progressSatge: Int = 0
    
    let screens: [OnboardingProgressble]
    
    var body: some View {
        if progressSatge < screens.count {
            let buttonText = progressSatge < screens.count - 1 ? "אישור".localized() : "שנצא לדרך?".localized()
            progreesView()
                .environmentObject(vm)
                .environment(\.managedObjectContext, manager.managedObjectContext)
                .wrapWithBottun(buttonText: buttonText,
                                preformAction: preformAction,
                                loadingForExternalActions: $externalActionLoading,
                                setButtonConfig: $buttonEnabled,
                                onTapGesture: { hideKeyboard() })
        }
    }
    
    @ViewBuilder private func progreesView() -> OnboardingProgressbleManagerView {
        OnboardingProgressbleManagerView(screens: screens,
                                         progreesSatge: $progressSatge,
                                         onAppear: { view in holder.value = view } ,
                                         noActionNeeded: { buttonEnabled = true },
                                         setButtonConfig: { isDone in buttonEnabled = isDone },
                                         otherAction: setExtenalLoading)
    }
    
    internal func preformAction(complete: @escaping (Bool) -> ()) {
        guard let profile = profiles.last else { return complete(false) }
        holder.value?.preformAction(manager: manager,
                                    profile: profile) { valid in
            complete(valid)
            guard valid else { return }
            approveProgress()
        }
    }
    
    private func approveProgress() {
        guard progressSatge < screens.count - 1 else {
            guard let profile = profiles.last else { return }
            profileSync.handele(profile: profile,
                                logedin: true)
            return router.navigateTo(.map)
        }
        progressSatge += 1
        buttonEnabled = false
    }
    
    private func setExtenalLoading() {
        externalActionLoading = true
        preformAction { _ in externalActionLoading = false }
    }
}

//#Preview {
//    OnboardingProgressbleBaseView()
//}
