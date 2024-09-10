//
//  RootView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
    @EnvironmentObject private var router: Router
    
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State private var showAlert = true
    
    private let main = DispatchQueue.main
    
    var body: some View {
        switch router.root {
        case .splash:
            Logo3DView()
                .task { initalScreen() }
            
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
    
    private func cleanLogin() {
        router.popToRoot()
    }
    
    private func initalScreen() {
        main.asyncAfter(deadline: .now() + 5.42) {
            profileSync.handleLogin(profile: profiles.last,
                                    didLogin: { _ in })
        }
    }
}

