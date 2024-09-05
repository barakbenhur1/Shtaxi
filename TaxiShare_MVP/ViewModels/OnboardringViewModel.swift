//
//  OnboardringVIewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation

internal class ComplitionHandeler: ObservableObject {
    func makeValid<T: Codable>(_ complition: @escaping () -> ()) -> (T) -> () { return { _ in complition() } }
    func makeValid<T: Codable>(_ complition: @escaping (T) -> ()) -> (T) -> () { return complition }
    func makeValid<T: Codable>(_ complition: @escaping (_ value: T...) -> ()) -> (_ value: T...) -> () { return complition }
    func makeValid<T: Codable>(_ complition: @escaping (_ value: T, _ value2: T, _ value3: T) -> ()) -> (T, T, T) -> () { return complition }
}

internal class ParameterHndeler: ObservableObject {
    func toDict(values: DictionaryRepresentable...) -> [String: Any] {
        var dict: [String: Any] = [:]
        values.forEach { dict.merge(dict: $0.dictionary()) }
        return dict
    }
}

class OnboardringViewModel: Network {
    private let auth = Authentication()
    private var handeler = ComplitionHandeler()
    private var pHandeler = ParameterHndeler()
    override var root: String { return "login" }
    
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (_ id: String, _ name: String, _ email: String) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
       
        auth.phoneVerify(verificationID: verificationID,
                         verificationCode: code,
                         phoneAuthModel: validComplition,
                         error: error)
    }
    
    func phoneAuth(phone: String, complition: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ()) {
        let validComplition = handeler.makeValid(complition)
       
        auth.phoneAuth(phone: phone,
                       auth: validComplition,
                       error: error)
    }
    
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
      
        send(url: path(""),
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
       
        send(url: path("get"),
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    func logout(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
       
        send(url: path("logout"),
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    func delete(id: String, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody)
       
        send(url: path("delete"),
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    func upload(profile: Profile?, uploadBody: UploadBody, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        guard let id = profile?.userID else { return error("no id") }
        let userIdBody = UserIdBody(id: id)
        let parameters = pHandeler.toDict(values: userIdBody, uploadBody)
        
        guard parameters.count > 1 else { return complition() }
        
        let newComplition: (UserExistModel) -> () = { result in
            guard result.exist else { return ProfileSyncHendeler.shared.removeAndPopToLogin(profile: profile,
                                                                                            massege: .unknown) }
            
            complition()
        }
        
        let validComplition = handeler.makeValid(newComplition)
        
        send(url: path("update"),
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
}
