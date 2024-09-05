//
//  LoginManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 01/09/2024.
//

import Foundation

enum LoginError: Error {
    case failed, deleted, unknown, retry
}
extension LoginError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failed:
            return "לוגין נכשל, אנא נסה שנית".localized()
        case .deleted:
            return "חשבונך נמחק, אנא בצע לוגין מחדש".localized()
        case .unknown:
            return "שגיאה: יוזר לא קיים במערכת".localized()
        case .retry:
            return "שגיאה: אנא בצע לוגין מחדש".localized()
        }
    }
}

struct ProfileSyncHendeler {
    static let shared = ProfileSyncHendeler()
    
    private let vm = OnboardringViewModel()
    private let router: Router
    private let manager: PersistenceController
    
    private init() {
        self.router = Router.shared
        self.manager = PersistenceController.shared
    }
    
    private func syncedLocalProfile(profile: Profile?, id: String) -> Profile {
        if let profile {
            return manager.replace(profile: profile,
                                   with: id)
        }
        else {
            return manager.new(id: id)
        }
    }
    
    func onboardingScreens(user: ProfileModel, syncedProfile: Profile, email: String, name: String, birthdate: String, gender: String) -> [OnboardingProgressble] {
        var screens: [OnboardingProgressble] = []
        
        if user.name.isEmpty {
            screens.append(.name(value: name))
        }
        else {
            manager.set(profile: syncedProfile,
                        name: user.name)
        }
        
        if user.birthdate.isEmpty {
            screens.append(.birthdate(value: birthdate))
        }
        else {
            manager.set(profile: syncedProfile,
                        date: user.birthdate)
        }
        
        if user.gender.isEmpty {
            let gender = !gender.isEmpty ? Int(gender) ?? nil : nil
            screens.append(.gender(value: gender))
        }
        else {
            manager.set(profile: syncedProfile,
                        gender: Int(user.gender)!)
        }
        
        if !user.rules {
            screens.append(.rules)
        }
        else {
            manager.set(profile: syncedProfile,
                        rules: user.rules)
        }
        
        if !user.phone.isEmpty {
            manager.set(profile: syncedProfile,
                        phone: user.phone)
        }
        
        if user.email.isEmpty, !email.isEmpty && email.isValidEmail() {
            vm.upload(profile: syncedProfile,
                      uploadBody: .init(email: email)) {
                manager.set(profile: syncedProfile,
                            email: email)
            } error: { error in print(error) }
        }
        
        return screens
    }
    
    func afterLogin(onboardingScreens: [OnboardingProgressble]) {
        if onboardingScreens.isEmpty { return router.navigateTo(.map) }
        else { return router.navigateTo(.onboarding(screens: onboardingScreens)) }
    }
    
    func afterLoginAsRoot(onboardingScreens: [OnboardingProgressble]) {
        if onboardingScreens.isEmpty { return router.root = .map }
        else { return router.root = .onboarding(screens: onboardingScreens) }
    }
    
    private func handleError(error: String, loginError: LoginError?) {
        print(error)
        goToLogin(message: loginError)
    }
    
    private func handleError(error: String) {
        print(error)
        goToLogin(message: nil)
    }
    
    func handleLoginTap(profile: Profile?, id: String?, name: String, email: String, birthdate: String, gender: String, didLogin: @escaping (Bool) -> () = { _ in }) {
        preform(profile: profile,
                id: id,
                name: name,
                email: email,
                birthdate: birthdate,
                gender: gender,
                didLogin: didLogin, navigteWith: afterLogin,
                error: handleError)
    }
    
    
    func handleLogin(profile: Profile?, id: String?, name: String, email: String, birthdate: String, gender: String, didLogin: @escaping (Bool) -> () = { _ in }) {
        preform(profile: profile,
                id: id,
                name: name,
                email: email,
                birthdate: birthdate,
                gender: gender,
                didLogin: didLogin,
                navigteWith: afterLoginAsRoot,
                error: { error,_ in handleError(error: error) })
    }
    
    private func preform(profile: Profile?, id: String?, name: String, email: String, birthdate: String, gender: String, didLogin: @escaping (Bool) -> (), navigteWith: @escaping ([OnboardingProgressble]) -> (), error: ((String, LoginError?) -> ())? = nil) {
        guard let id, !id.isEmpty else {
            removeAndPopToLogin(profile: profile)
            return didLogin(false)
        }
        
        vm.getUser(id: id) { result in
            let serverProfileExist = result.exist
            
            if let profile, !serverProfileExist {
                removeAndPopToLogin(profile: profile,
                                    massege: .deleted)
                return didLogin(false)
            }
            
            vm.login(id: id) { user in
                let syncedLocalProfile = syncedLocalProfile(profile: profile, id: id)
                
                let onboardingScreens = onboardingScreens(user: user,
                                                          syncedProfile: syncedLocalProfile,
                                                          email: email,
                                                          name: name,
                                                          birthdate: birthdate,
                                                          gender: gender)
                
                didLogin(true)
                navigteWith(onboardingScreens)
            } error: { err in
                error?(err, .failed)
                return didLogin(false)
            }
        } error: { err in
            error?(err, .failed)
            return didLogin(false)
        }
    }
    
    func removeAndPopToLogin(profile: Profile?, massege: LoginError? = nil) {
        removeLocalProfile(profile: profile)
        goToLogin(message: massege)
    }
    
    private func removeLocalProfile(profile: Profile?) {
        guard let profile else { return }
        manager.delete(profile: profile)
    }
    
    func goToLogin(message: LoginError? = nil) {
        router.popToRoot(message: message)
    }
}
