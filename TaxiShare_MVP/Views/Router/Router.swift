//
//  Coordinator.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

private class TransactionManager {
    static let shared = TransactionManager()
    var value: Bool = false { didSet { UINavigationBar.setAnimationsEnabled(value) } }
    init() {}
}

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
    
    // Used to programatically control our navigation stack
    @Published var path: NavigationPath = NavigationPath()
    @Published var root: Root = .splash
    private var transition = TransactionManager.shared
    
    private init() {}
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView(transitionAnimation: transition.value)
                .navigationBarBackButtonHidden()
            
        case .pinCode(let phone, let verificationID):
            PinCodeView(transitionAnimation: transition.value,
                        phone: phone,
                        verificationID: verificationID)
            .navigationBarBackButtonHidden()
            
        case .onboarding(let screens):
            OnboardingProgressbleContainerView(transitionAnimation: transition.value,
                                                screens: screens)
            .navigationBarBackButtonHidden()
            
        case .map:
            MapView(transitionAnimation: transition.value)
                .navigationBarBackButtonHidden()
            
        case .filter:
            FilterView(transitionAnimation: transition.value)
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route, animate: Bool = true) {
        transition.value = animate
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
