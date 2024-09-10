//
//  LoginManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 01/09/2024.
//

import Foundation
import SwiftUI

// MARK: LoginError
enum LoginError: Error {
    case failed, retry, deleted, unknown
}

extension LoginError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failed:
            return "לוגין נכשל, אנא נסה שנית".localized()
        case .retry:
            return "שגיאה: אנא בצע לוגין מחדש".localized()
        case .deleted:
            return "חשבונך נמחק, אנא בצע לוגין מחדש".localized()
        case .unknown:
            return "שגיאה: יוזר לא קיים במערכת".localized()
        }
    }
}

// MARK: ProfileSyncHendeler
class ProfileSyncHendeler: Shared {
    @Published private var router: Router
    @Published private var manager: CoreDataManager
    @Published private var vm: OnboardingViewModel
    
    // MARK: init
    private override init() {
        self.router = Router.shared
        self.manager = CoreDataManager.shared
        self.vm = ViewModelProvider.shared.vm()
    }
    
    // MARK: syncedLocalProfile
    /// - Parameters:
    ///  - profile - local profile
    ///  - id - user id
    private func syncedLocalProfile(profile: Profile?, id: String) -> Profile {
        if let profile {
            return manager.replace(profile: profile,
                                   with: id)
        }
        else {
            return manager.new(id: id)
        }
    }
    
    // MARK: handleError
    /// - Parameters:
    ///  - error - server error
    ///  - loginError - local error
    private func handleError(error: String, loginError: LoginError? = nil) {
        print(error)
        goToLogin(message: loginError)
    }
    
    // MARK: removeLocalProfile
    /// - Parameter Profile - local profile
    private func removeLocalProfile(profile: Profile?) {
        guard let profile else { return }
        manager.delete(profile: profile)
    }
    
    // MARK: preform
    /// - Parameters:
    ///  - Profile - local profile
    ///  -  id
    ///  -  email
    ///  -  name
    ///  -  birthdate
    ///  -  gender
    ///  -  didLogin - return if login successful
    private func preform(profile: Profile?, id: String?, phone: String = "", name: String = "", email: String = "", birthdate: String = "", gender: String = "", didLogin: @escaping (Bool) -> (), navigteWith: @escaping ([OnboardingProgressble]) -> (), error: ((String, LoginError?) -> ())? = nil) {
        guard let id, !id.isEmpty else {
            removeAndPopToLogin(profile: profile)
            return didLogin(false)
        }
        
        vm.getUser(id: id) { [weak self] result in
            guard let self else { return didLogin(false) }
            let serverProfileExist = result.exist
            
            if let profile, !serverProfileExist {
                removeAndPopToLogin(profile: profile,
                                    massege: .deleted)
                return didLogin(false)
            }
            
            vm.login(id: id) { [weak self] user in
                guard let self else { return didLogin(false) }
                let syncedLocalProfile = syncedLocalProfile(profile: profile, id: id)
                
                let onboardingScreens = onboardingScreens(user: user,
                                                          syncedProfile: syncedLocalProfile,
                                                          name: name,
                                                          birthdate: birthdate,
                                                          gender: gender)
                
                if user.email.isEmpty && !email.isEmpty && email.isValidEmail() {
                    vm.update(profile: syncedLocalProfile,
                              updateBody: .init(email: email),
                              error: { error in print(error) })
                }
                
                if user.phone.isEmpty && !phone.isEmpty && phone.isValidPhone() {
                    vm.update(profile: syncedLocalProfile,
                              updateBody: .init(phone: phone),
                              error: { [weak self] error in
                        print(error)
                        guard let self else { return }
                        return removeAndPopToLogin(profile: syncedLocalProfile,
                                                   massege: .retry,
                                                   animate: true)
                    })
                }
                
                handele(profile: syncedLocalProfile,
                        logedin: onboardingScreens.isEmpty)
                
                didLogin(true)
                return navigteWith(onboardingScreens)
            } error: { err in
                error?(err, .failed)
                return didLogin(false)
            }
        } error: { err in
            error?(err, .failed)
            return didLogin(false)
        }
    }
    
    // MARK: public
    
    // MARK: onboardingScreens
    /// - Parameters:
    ///  - user - server profile
    ///  -  syncedProfile - local profile
    ///  -  email
    ///  -  name
    ///  -  birthdate
    ///  -  gender
    func onboardingScreens(user: ProfileModel, syncedProfile: Profile, name: String, birthdate: String, gender: String) -> [OnboardingProgressble] {
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
        
        return screens
    }
    
    // MARK: handele
    /// - Parameters:
    ///  - Profile - local profile
    ///  - logedin - is user  logedin
    func handele(profile: Profile?, logedin: Bool) {
        guard let profile else { return }
        manager.set(profile: profile,
                    logedin: logedin)
    }
    
    // MARK: onboardingScreens
    /// - Parameter onboardingScreens
    func afterLogin(onboardingScreens: [OnboardingProgressble]) {
        if onboardingScreens.isEmpty { return router.navigateTo(.map) }
        else { return router.navigateTo(.onboarding(screens: onboardingScreens)) }
    }
    
    // MARK: afterLoginAsRoot
    /// - Parameter onboardingScreens
    func afterLoginAsRoot(onboardingScreens: [OnboardingProgressble]) {
        if onboardingScreens.isEmpty { return router.root = .map }
        else { return router.root = .onboarding(screens: onboardingScreens) }
    }
    
    // MARK: handleLoginTap - from tap
    /// - Parameters:
    ///  - profile - local profile
    ///  - id
    ///  -  email
    ///  -  name
    ///  -  birthdate
    ///  -  gender
    ///  -  didLogin - return if login successful
    func handleLoginTap(profile: Profile?, id: String?, email: String = "", phone: String = "", name: String = "", birthdate: String = "", gender: String = "", didLogin: @escaping (Bool) -> () = { _ in }) {
        preform(profile: profile,
                id: id,
                phone: phone,
                name: name,
                email: email,
                birthdate: birthdate,
                gender: gender,
                didLogin: didLogin,
                navigteWith: afterLogin,
                error: handleError)
    }
    
    
    // MARK: handleLogin - auto login
    /// - Parameters:
    ///  - profile - local profile
    ///  - didLogin - return if login successful
    func handleLogin(profile: Profile?, didLogin: @escaping (Bool) -> () = { _ in }) {
        guard let logedin = profile?.logedin, logedin else {
            removeAndPopToLogin(profile: profile)
            return didLogin(false)
        }
        preform(profile: profile,
                id: profile?.userID,
                didLogin: didLogin,
                navigteWith: afterLoginAsRoot,
                error: handleError)
    }
    
    // MARK: removeAndPopToLogin
    /// - Parameters:
    ///  - Profile - local profile
    ///  - message - local error
    ///  - animate - animate navigation
    func removeAndPopToLogin(profile: Profile?, massege: LoginError? = nil, animate: Bool = false) {
        removeLocalProfile(profile: profile)
        goToLogin(message: massege,
                  animate: animate)
    }
    
    // MARK: goToLogin
    /// - Parameters:
    ///  - message - local error
    ///  - animate - animate navigation
    func goToLogin(message: LoginError? = nil, animate: Bool = false) {
        router.popToRoot(message: message,
                         animate: animate)
    }
}
