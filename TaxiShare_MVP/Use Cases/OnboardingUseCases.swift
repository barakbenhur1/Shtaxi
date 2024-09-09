//
//  OnboardingUseCases.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

struct OnboardingUseCases: USeCase, OnboardingRepository {
    let repo: OnboardingRepository
    
    func logoutProviders() {
        repo.logoutProviders()
    }
    
    func googleAuth(complition: @escaping (GoogleAuthModel) -> (), error: @escaping (String) -> ()) {
        repo.googleAuth(complition: complition, error: error)
    }
    
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> (), error: @escaping (String) -> ()) {
        repo.facebookAuth(complition: complition, error: error)
    }
    
    func appleAuth() {
        repo.appleAuth()
    }
    
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (PhoneAuthModel) -> (), error: @escaping (String?) -> ()) {
        repo.verifayPinCode(verificationID: verificationID, code: code, complition: complition, error: error)
    }
    
    func phoneAuth(phone: String, complition: @escaping (String) -> (), error: @escaping (String?) -> ()) {
        repo.phoneAuth(phone: phone, complition: complition, error: error)
    }
    
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        repo.delete(id: id, complition: complition, error: error)
    }
    
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        repo.logout(id: id, complition: complition, error: error)
    }
    
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        repo.login(id: id, complition: complition, error: error)
    }
    
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        repo.getUser(id: id, complition: complition, error: error)
    }
    
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        repo.update(profile: profile, updateBody: updateBody, complition: complition, error: error)
    }
}
