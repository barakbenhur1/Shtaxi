//
//  OnboardingRepository.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

protocol OnboardingRepository {
    func logoutProviders()
    func googleAuth(complition: @escaping (GoogleAuthModel) -> (), error: @escaping (String) -> ())
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> (), error: @escaping (String) -> ())
    func appleAuth()
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (PhoneAuthModel) -> (), error: @escaping (String?) -> ())
    func phoneAuth(phone: String, complition: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ())
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ())
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ())
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ())
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ())
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> (), error: @escaping (String) -> ())
}
