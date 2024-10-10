//
//  RootView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct RootView: View {
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
    @EnvironmentObject private var launchScreenManager: LaunchScreenStateManager
    @EnvironmentObject private var vmProvider: ViewModelProvider
    
    @State private var showAlert = true
    @State private var intilize = true
    
    var body: some View {
        ZStack(alignment: .center) {
            switch router.root {
            case .login(let message):
                LoginView()
                    .onAppear { showAlert = message != nil }
                    .customAlert("הודעה מערכת",
                                 isPresented: $showAlert,
                                 actionText: "הבנתי",
                                 action: cleanLogin)
                {
                    if let message {
                        Text(message)
                    }
                }
            case .onboarding(let screens): /// won't happen
                OnboardingProgressbleContainerView(screens: screens)
            case .map:
                MapView()
            }
        }
        .onAppear { initalScreen() }
    }
    
    private func cleanLogin() {
        router.popToRoot()
    }
    
    private func initalScreen() {
        guard intilize else { return }
        intilize = false
        profileSync.handleLogin(profile: profiles.last,
                                didLogin: { _ in launchScreenManager.dismiss() } )
    }
}

