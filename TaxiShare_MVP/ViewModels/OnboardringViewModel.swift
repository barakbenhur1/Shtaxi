//
//  OnboardringVIewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation
import SwiftUI

// MARK: ComplitionHandeler
private class ComplitionHandeler: ObservableObject {
    func makeValid<T: Codable>(_ complition: @escaping () -> ()) -> (T) -> () { return { _ in complition() } }
    func makeValid<T: Codable>(_ complition: @escaping (T) -> ()) -> (T) -> () { return complition }
    func makeValid<T: Codable>(_ complition: @escaping (_ value: T, _ value2: T, _ value3: T) -> ()) -> (T, T, T) -> () { return complition }
//    func makeValid<T: Codable>(_ complition: @escaping (_ value: T...) -> ()) -> (_ value: T...) -> () { return complition }
}

// MARK: ParameterHndeler
private class ParameterHndeler: ObservableObject {
    // MARK: toDict
    /// - Parameter values
    func toDict(values: DictionaryRepresentable...) -> [String: Any] {
        var dict: [String: Any] = [:]
        values.forEach { dict.merge(dict: $0.dictionary()) }
        return dict
    }
}

// MARK: OnboardringViewModel
class OnboardringViewModel: Network {
    override internal var root: String { return "login" }
    
    @StateObject private var handeler = ComplitionHandeler()
    @StateObject private var pHandeler = ParameterHndeler()
    @StateObject private var auth = Authentication.shared
    
    // MARK: public api
    
    // MARK: verifayPinCode
    /// - Parameter verificationID - sms verification id
    /// - Parameter code - sms code
    /// - Parameter complition
    /// - Parameter error
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (_ id: String, _ name: String, _ email: String) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.phoneVerify(verificationID: verificationID,
                         verificationCode: code,
                         phoneAuthModel: validComplition,
                         error: error)
    }
    
    // MARK: phoneAuth
    /// - Parameter phone - phone number
    /// - Parameter complition
    /// - Parameter error
    func phoneAuth(phone: String, complition: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.phoneAuth(phone: phone,
                       auth: validComplition,
                       error: error)
    }
    
    // MARK: googleAuth
    /// - Parameter complition
    func googleAuth(complition: @escaping (GoogleAuthModel?) -> ())  {
        let validComplition = handeler.makeValid(complition)
        auth.googleOauth(complition: validComplition)
    }
    
    // MARK: facebookAuth
    /// - Parameter complition
    func facebookAuth(complition: @escaping (FacebookAuthModel) -> ()) {
        let validComplition = handeler.makeValid(complition)
        auth.facebookAuth(facebookAuthModel: validComplition)
    }
    
    // MARK: login
    /// - Parameter id - user id
    /// - Parameter complition
    /// - Parameter error
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
    /// - Parameter id - user id
    /// - Parameter complition
    /// - Parameter error
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
    
    // MARK: logout
    /// - Parameter id - user id
    /// - Parameter complition
    /// - Parameter error
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        send(method: .post,
             route: "logout",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: delete
    /// - Parameter id - user id
    /// - Parameter complition
    /// - Parameter error
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        send(method: .post,
             route: "delete",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: update
    /// - Parameter id - user id
    /// - Parameter updateBody - paramers to update
    /// - Parameter complition
    /// - Parameter error
    func update(profile: Profile?, updateBody: UpdateBody, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        guard let id = profile?.userID else { return error("no id") }
        let newComplition: (UserExistModel) -> () = { result in
            guard result.exist else { return ProfileSyncHendeler.shared.removeAndPopToLogin(profile: profile,
                                                                                            massege: .unknown) }
            complition()
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
