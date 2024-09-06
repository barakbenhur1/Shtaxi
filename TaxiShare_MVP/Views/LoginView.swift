//
//  ContentView.swift
//  Taxi_MVP
//
//  Created by Barak Ben Hur on 26/06/2024.
//

import SwiftUI
import CoreData
import GoogleSignIn

struct LoginView: ViewWithTransition, ProfileHandeler {
    @EnvironmentObject var router: Router
    @EnvironmentObject var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State internal var buttonEnabled: Bool = false
    @State internal var externalActionLoading: Bool? = false
    
    private let vm = OnboardringViewModel()
    @State private var holder = Holder<String>()
    
    let transitionAnimation: Bool
    
    var body: some View {
        onboardingLoginView()
            .wrapWithBottun(buttonText: "אישור".localized(),
                            preformAction: preformAction,
                            loadingForExternalActions: $externalActionLoading,
                            setButtonConfig: $buttonEnabled)
    }
    
    @ViewBuilder private func onboardingLoginView() -> some View {
        OnboardingLoginView(didSignup: didSignup,
                            didFillPhone: didFillPhone)
    }
    
    func preformAction(complete: @escaping (Bool) -> ()) {
        guard let phone = holder.value else { return complete(false) }
        vm.phoneAuth(phone: phone) { verificationID in
            complete(true)
            router.navigateTo(.pinCode(phone: phone,
                                       verificationID: verificationID))
        } error: { err in
            complete(false)
            guard let err else { return }
            print(err)
        }
    }
    
    private func didSignup(_ id: String, _ name: String?, _ email: String?, _ birthdate: String?, _ gender: String?) {
        externalActionLoading = true
        ProfileSyncHendeler.shared.handleLoginTap(profile: profiles.last,
                                                  id: id,
                                                  email: email ?? "",
                                                  name: name ?? "",
                                                  birthdate: birthdate ?? "",
                                                  gender: gender ?? "") { _ in   externalActionLoading = false }
    }
    
    func didFillPhone(number: String) {
        holder.value = number
        buttonEnabled = number.count == 11
    }
}
