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
    @EnvironmentObject private var manager: CoreDataManager
    
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @StateObject private var vm = OnboardingViewModel()
    @StateObject private var mvm = MapViewViewModel()
    
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
                             actionText:"הבנתי",
                             action: cleanLogin)
            {
                if let message {
                    Text(message)
                }
            }
            .environmentObject(router)
            .environmentObject(profileSync)
            .environmentObject(vm)
            .environment(\.managedObjectContext, manager.managedObjectContext)
            .onAppear { showAlert = message != nil }
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(screens: screens)
                .environmentObject(vm)
                .environmentObject(router)
                .environmentObject(profileSync)
                .environment(\.managedObjectContext, manager.managedObjectContext)
        case .map:
            MapView()
                .environmentObject(router)
                .environmentObject(vm)
                .environmentObject(mvm)
                .environmentObject(profileSync)
                .environment(\.managedObjectContext, manager.managedObjectContext)
        }
    }
    
    private func cleanLogin() {
        router.root = .login(message: nil)
    }
    
    private func initalScreen() {
        main.asyncAfter(deadline: .now() + 4) {
            profileSync.handleLogin(profile: profiles.last,
                                    didLogin: { _ in })
        }
    }
}

