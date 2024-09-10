//
//  OnboardingViewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation
import SwiftUI

// MARK: OnboardingViewModel
class OnboardringDataSource: Network, OnboardingRepository {
    override internal var root: String { return "login" }
    
    private let auth = Authentication.shared
    private let manager = CoreDataManager.shared
    private let handeler = ComplitionHandeler()
    private let pHandeler = ParameterHndeler()
    
    // MARK: logoutProviders
    internal func logoutProviders() {
        auth.logout()
    }
    
    // MARK: appleAuth
    func appleAuth()  {
        logoutProviders()
    }
    
    // MARK: googleAuth
    /// - Parameters:
    ///  - complition
    ///  - error
    func googleAuth(complition: @escaping (GoogleAuthModel) -> (), error: @escaping (String) -> ())  {
        let validComplition = handeler.makeValid(complition)
        auth.googleAuth(complition: validComplition,
                        error: error)
    }
    
    // MARK: facebookAuth
    /// - Parameters:
    ///  - complition
    ///  - error
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.facebookAuth(complition: validComplition,
                          error: error)
    }
    
    // MARK: verifayPinCode
    /// - Parameters:
    ///  - verificationID - sms verification id
    ///  - code - sms code
    ///  - complition
    ///  - error
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (PhoneAuthModel) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.phoneVerify(verificationID: verificationID,
                         verificationCode: code,
                         phoneAuthModel: validComplition,
                         error: error)
    }
    
    // MARK: phoneAuth
    /// - Parameters:
    ///  - phone - phone number
    ///  - complition
    ///  - error
    func phoneAuth(phone: String, complition: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.phoneAuth(phone: phone,
                       auth: validComplition,
                       error: error)
    }
    
    // MARK: delete
    /// - Parameters:
    ///  - id - user id
    ///  - complition
    ///  - error
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        logoutProviders()
        send(method: .post,
             route: "delete",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: logout
    /// - Parameters:
    ///  - id - user id
    ///  - complition
    ///  - error
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        logoutProviders()
        send(method: .post,
             route: "logout",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: login
    /// - Parameters:
    ///  - id - user id
    ///  - complition
    ///  - error
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        send(method: .post,
             route: "",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: getUser
    /// - Parameters:
    ///  - id - user id
    ///  - complition
    ///  - error
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        send(method: .post,
             route: "get",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    /// - Parameters:
    ///  - id - user id
    ///  - updateBody - paramers to update
    ///  - complition
    ///  - error
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        guard let id = profile?.userID else { return error("no id") }
        let newComplition: (UserExistModel) -> () = { [weak self] result in
            guard result.exist else {
                guard let self else { return }
                return handleNoServerProfile(profile: profile)
            }
            complition()
            guard let self else { return }
            return handeleCoreData(profile: profile,
                            updateBody: updateBody)
        }
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody, updateBody)
        let validComplition = handeler.makeValid(newComplition)
        guard parameters.count > 1 else { return complition() }
        send(method: .post,
             route: "update",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
}

extension OnboardringDataSource {
    // MARK: handleNoServerProfile
    /// - Parameter profile
    private func handleNoServerProfile(profile: Profile?) {
        NotificationCenter.default.post(name: .popToLogin,
                                        object: LoginError.unknown)
        guard let profile else { return }
        manager.delete(profile: profile)
    }
    
    // MARK: handeleCoreData
    /// - Parameters:
    ///  - profile
    ///  - updateBody
    private func handeleCoreData(profile: Profile?, updateBody: UpdateBody) {
        if let update = updateBody.getValue(), let profile {
            switch update {
            case let (key, value as String) where key == .email:
                manager.set(profile: profile,
                            email: value)
            case let (key, value as String) where key == .phone:
                manager.set(profile: profile,
                            phone: value)
            case let (key, value as String) where key == .name:
                manager.set(profile: profile,
                            name: value)
            case let (key, value as String) where key == .birthdate:
                manager.set(profile: profile,
                            date: value)
            case let (key, value as Int) where key == .gender:
                manager.set(profile: profile,
                            gender: value)
            case let (key, value as Bool) where key == .rules:
                manager.set(profile: profile,
                            rules: value)
            default: return
            }
        }
    }
}
