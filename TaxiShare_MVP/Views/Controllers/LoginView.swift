//
//  ContentView.swift
//  Taxi_MVP
//
//  Created by Barak Ben Hur on 26/06/2024.
//

import SwiftUI
import CoreData
import GoogleSignIn

struct LoginView: View, ProfileHandeler {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var vmProvider: ViewModelProvider
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
   
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State internal var buttonEnabled: Bool = false
    @State internal var externalActionLoading: Bool? = false
    
    @State private var holder = Holder<String>()
    
    private var vm: OnboardingViewModel { return vmProvider.viewModel() }
    
    var body: some View {
        onboardingLoginView()
            .wrapWithBottun(buttonText: "אישור".localized(),
                            preformAction: preformAction,
                            loadingForExternalActions: $externalActionLoading,
                            setButtonConfig: $buttonEnabled)
    }
    
    @ViewBuilder private func onboardingLoginView() -> some View {
        OnboardingLoginView(vm: vmProvider.viewModel(),
                            didSignup: didSignup,
                            didFillPhone: didFillPhone)
    }
    
    func preformAction(complete: @escaping (Bool) -> ()) {
        guard let phone = holder.value else { return complete(false) }
        vm.phoneAuth(phone: phone) { verificationID in
            complete(true)
            return router.navigateTo(.pinCode(phone: phone,
                                              verificationID: verificationID))
        } error: { err in
            if let err { print(err) }
            return complete(false)
        }
    }
    
    private func didSignup(_ id: String, _ name: String?, _ email: String?, _ birthdate: String?, _ gender: String?) {
        externalActionLoading = true
        profileSync.handleLoginTap(profile: profiles.last,
                                                  id: id,
                                                  email: email ?? "",
                                                  name: name ?? "",
                                                  birthdate: birthdate ?? "",
                                                  gender: gender ?? "") { _ in externalActionLoading = false }
    }
    
    func didFillPhone(number: String) {
        holder.value = number
        buttonEnabled = number.count == 11
    }
}
