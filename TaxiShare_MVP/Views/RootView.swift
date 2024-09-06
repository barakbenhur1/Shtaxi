//
//  RootView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct RootView: ViewWithTransition {
    let transitionAnimation: Bool = false
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    @State private var showAlert = true
    
    var body: some View {
        switch router.root {
        case .splash:
            Logo3DView()
                .task { initalScreen() }
            
        case .login(let message):
            LoginView(transitionAnimation: true)
                .customAlert("הודעה מערכת",
                             isPresented:  $showAlert,
                             actionText:"הבנתי",
                             action: { router.root = .login(message: nil) }
                ) {
                    if let message {
                        Text(message)
                    }
                }
                .environmentObject(router)
                .onAppear { showAlert = message != nil }
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(transitionAnimation: true,
                                               screens: screens)
            .environmentObject(router)
        case .map:
            MapView(transitionAnimation: true)
                .environmentObject(router)
        }
    }
    
    private func initalScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let profile = profiles.last
            ProfileSyncHendeler.shared.handleLogin(profile: profile,
                                                   id: profile?.userID,
                                                   name: "",
                                                   email: "",
                                                   birthdate: "",
                                                   gender: "") { _ in }
        }
    }
}

