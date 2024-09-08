//
//  OnboardingdataSourcesitoryImpl.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

struct OnboardingRepositoryImpl: OnboardingRepository {
    let dataSource: OnboardingRepository
    
    func logoutProviders() {
        dataSource.logoutProviders()
    }
    
    func googleAuth(complition: @escaping (GoogleAuthModel) -> (), error: @escaping (String) -> ()) {
        dataSource.googleAuth(complition: complition, error: error)
    }
    
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> (), error: @escaping (String) -> ()) {
        dataSource.facebookAuth(complition: complition, error: error)
    }
    
    func appleAuth() {
        dataSource.appleAuth()
    }
    
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (PhoneAuthModel) -> (), error: @escaping (String?) -> ()) {
        dataSource.verifayPinCode(verificationID: verificationID, code: code, complition: complition, error: error)
    }
    
    func phoneAuth(phone: String, complition: @escaping (String) -> (), error: @escaping (String?) -> ()) {
        dataSource.phoneAuth(phone: phone, complition: complition, error: error)
    }
    
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        dataSource.delete(id: id, complition: complition, error: error)
    }
    
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        dataSource.logout(id: id, complition: complition, error: error)
    }
    
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        dataSource.login(id: id, complition: complition, error: error)
    }
    
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        dataSource.getUser(id: id, complition: complition, error: error)
    }
    
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        dataSource.update(profile: profile, updateBody: updateBody, complition: complition, error: error)
    }
}
