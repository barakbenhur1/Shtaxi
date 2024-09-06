//
//  RootView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    @StateObject private var profileSync = ProfileSyncHendeler.shared
    @StateObject private var vm = OnboardringViewModel()
    @StateObject private var mvm = MapViewViewModel()
    
    @State private var showAlert = true
    
    var body: some View {
        switch router.root {
        case .splash:
            Logo3DView()
                .task { initalScreen() }
            
        case .login(let message):
            LoginView()
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
                .environmentObject(profileSync)
                .environmentObject(vm)
                .onAppear { showAlert = message != nil }
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(screens: screens)
            .environmentObject(vm)
            .environmentObject(router)
        case .map:
            MapView()
                .environmentObject(router)
                .environmentObject(vm)
                .environmentObject(mvm)
                .environmentObject(profileSync)
        }
    }
    
    private func initalScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let profile = profiles.last
            profileSync.handleLogin(profile: profile,
                                                   id: profile?.userID,
                                                   name: "",
                                                   email: "",
                                                   birthdate: "",
                                                   gender: "") { _ in }
        }
    }
}

