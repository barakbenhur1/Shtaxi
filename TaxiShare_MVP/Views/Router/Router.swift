//
//  Coordinator.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

class Router: ObservableObject {
    static let shared = Router()
    // Contains the possible destinations in our Router
    enum Route: Codable, Hashable {
        case login
        case pinCode(phone: String, verificationID: String)
        case onboarding(screens: [OnboardingProgressble])
        case map
        case filter
    }
    
    enum Root: Codable, Hashable {
        case splash, login(message: String?), onboarding(screens: [OnboardingProgressble]), map
    }
    
    @StateObject private var vm = OnboardringViewModel()
    @StateObject private var mapVM = MapViewViewModel()
    @StateObject private var profileSync = ProfileSyncHendeler.shared
    
    @Published var root: Root = .splash
    @Published var path: NavigationPath = NavigationPath()
   
    private init() {}
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView()
                .environmentObject(vm)
                .navigationBarBackButtonHidden()
            
        case .pinCode(let phone, let verificationID):
            PinCodeView(phone: phone,
                        verificationID: verificationID)
            .environmentObject(vm)
            .environmentObject(profileSync)
            .navigationBarBackButtonHidden()
            
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(screens: screens)
                .environmentObject(profileSync)
                .environmentObject(vm)
                .navigationBarBackButtonHidden()
            
        case .map:
            MapView()
                .environmentObject(vm)
                .environmentObject(mapVM)
                .environmentObject(profileSync)
                .navigationBarBackButtonHidden()
            
        case .filter:
            FilterView()
//                .environmentObject(OnboardringViewModel())
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route, animate: Bool = true) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot(message: LoginError? = nil) {
        root = .login(message: message?.localizedDescription)
        path.removeLast(path.count)
    }
}
