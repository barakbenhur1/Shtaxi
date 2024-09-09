//
//  OnboardingViewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import SwiftUI

class OnboardingViewModel: ViewModel {
    internal let useCases = OnboardingUseCases(repo: OnboardingRepositoryImpl(dataSource: OnboardringDataSource()))
    
    required init() {}
    
    func logoutProviders() {
        useCases.logoutProviders()
    }
    
    func googleAuth(complition: @escaping (GoogleAuthModel) -> (), error: @escaping (String) -> ()) {
        useCases.googleAuth(complition: complition, error: error)
    }
    
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> (), error: @escaping (String) -> ()) {
        useCases.facebookAuth(complition: complition, error: error)
    }
    
    func appleAuth() {
        useCases.appleAuth()
    }
    
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (PhoneAuthModel) -> (), error: @escaping (String?) -> ()) {
        useCases.verifayPinCode(verificationID: verificationID, code: code, complition: complition, error: error)
    }
    
    func phoneAuth(phone: String, complition: @escaping (String) -> (), error: @escaping (String?) -> ()) {
        useCases.phoneAuth(phone: phone, complition: complition, error: error)
    }
    
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        useCases.delete(id: id, complition: complition, error: error)
    }
    
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        useCases.logout(id: id, complition: complition, error: error)
    }
    
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        useCases.login(id: id, complition: complition, error: error)
    }
    
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        useCases.getUser(id: id, complition: complition, error: error)
    }
    
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> () = {}, error: @escaping (String) -> ()) {
        useCases.update(profile: profile, updateBody: updateBody, complition: complition, error: error)
    }
}
