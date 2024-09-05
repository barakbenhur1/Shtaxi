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
    
    @State private var logoSize = CGSize(width: 1,
                                         height: 1)
    @State private var logoOpticity = 1.00
    
    var body: some View {
        switch router.root {
        case .splash:
            TLogo(shape: Rectangle(),
                  size: 128)
            .scaleEffect(logoSize,
                         anchor: .center)
            .opacity(logoOpticity)
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
        withAnimation(.interactiveSpring(duration: 1.5)
            .repeatForever(autoreverses: true)) {
            logoSize.width = 1.4
            logoSize.height = 1.4
                logoOpticity = 0.6
            }
        
        let profile = profiles.last
        ProfileSyncHendeler.shared.handleLogin(profile: profile,
                                               id: profile?.userID,
                                               name: "",
                                               email: "",
                                               birthdate: "",
                                               gender: "") { _ in }
    }
}

