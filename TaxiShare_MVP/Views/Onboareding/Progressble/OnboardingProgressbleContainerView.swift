//
//  OnboardingProgressbleBaseView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/08/2024.
//

import SwiftUI

struct OnboardingProgressbleContainerView: ViewWithTransition, ProfileHandeler {
    @EnvironmentObject private var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    @EnvironmentObject var router: Router
    
    @State internal var holder = Holder<any ProfileUpdater>()
    @State internal var buttonEnabled: Bool = false
    @State internal var externalActionLoading: Bool? = false
    @State private var progreesSatge: Int = 0
    @State private var buttonConfig: TButtonConfig = .defulat(state: .disabled,
                                                              dimantions: .full)
    internal let vm = OnboardringViewModel()
    
    let transitionAnimation: Bool
    let screens: [OnboardingProgressble]
    
    var body: some View {
        if progreesSatge < screens.count {
            let buttonText = progreesSatge < screens.count - 1 ? "אישור".localized() : "שנצא לדרך?".localized()
            progreesView()
                .wrapWithBottun(buttonText: buttonText,
                                preformAction: preformAction, 
                                loadingForExternalActions: $externalActionLoading,
                                setButtonConfig: $buttonEnabled,
                                onTapGesture: { hideKeyboard() })
        }
    }
    
    @ViewBuilder private func progreesView() -> OnboardingProgressbleManagerView {
        OnboardingProgressbleManagerView(screens: screens,
                                         progreesSatge: $progreesSatge,
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
    
    private func setExtenalLoading() {
        externalActionLoading = true
        preformAction { _ in externalActionLoading = false }
    }
    
    private func approveProgress() {
        guard progreesSatge < screens.count - 1 else { return router.navigateTo(.map) }
        progreesSatge += 1
        buttonEnabled = false
    }
}

//#Preview {
//    OnboardingProgressbleBaseView()
//}
