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
    
    @Published var root: Root = .splash
    @Published var path: NavigationPath = NavigationPath()
    
    @Published private var navigationAnimation: Bool = false {
        didSet {
            UINavigationBar.setAnimationsEnabled(navigationAnimation)
        }
    }
   
    private init() {}
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView()
                .navigationBarBackButtonHidden()
            
        case .pinCode(let phone, let verificationID):
            PinCodeView(phone: phone,
                        verificationID: verificationID)
            .navigationBarBackButtonHidden()
            
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(screens: screens)
                .navigationBarBackButtonHidden()
            
        case .map:
            MapView()
                .navigationBarBackButtonHidden()
            
        case .filter:
            FilterView()
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route, animate: Bool = true) {
        navigationAnimation = animate
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack(animate: Bool = true) {
        navigationAnimation = animate
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot(message: LoginError? = nil, animate: Bool = false) {
        navigationAnimation = animate
        root = .login(message: message?.localizedDescription)
        path.removeLast(path.count)
    }
}
