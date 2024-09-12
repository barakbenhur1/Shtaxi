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
    
    @State private var showAlert = true
    
    private let main = DispatchQueue.main
    
    var body: some View {
        ZStack(alignment: .center) {
            switch router.root {
            case .login(let message):
                LoginView()
                    .customAlert("הודעה מערכת",
                                 isPresented: $showAlert,
                                 actionText: "הבנתי",
                                 action: cleanLogin)
                {
                    if let message {
                        Text(message)
                    }
                }
                .onAppear { showAlert = message != nil }
            case .onboarding(let screens): /// won't happen
                OnboardingProgressbleContainerView(screens: screens)
            case .map:
                MapView()
            }
        }
        .task { initalScreen() }
    }
    
    private func cleanLogin() {
        router.popToRoot()
    }
    
    
    private func initalScreen() {
        profileSync.handleLogin(profile: profiles.last,
                                didLogin: { _ in  main.asyncAfter(deadline: .now() + 10) { launchScreenManager.dismiss() } } )
    }
}

