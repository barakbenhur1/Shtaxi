//
//  OnboardringVIewModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation

class OnboardringViewModel: Network {
    private let auth = Authentication()
    override var root: String { return "login" }
    
    func verifayPinCode(verificationID: String, code: String, complition: @escaping (_ id: String, _ name: String, _ email: String) -> (), error: @escaping (String?) -> ()) {
        auth.phoneVerify(verificationID: verificationID, verificationCode: code, phoneAuthModel: complition, error: error)
    }
    
    func phoneAuth(phone: String, complition: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ()) {
        auth.phoneAuth(phone: phone, auth: complition, error: error)
    }
    
    func login(id: String, complition: @escaping (ProfileModel) -> (), error: @escaping (String) -> ()) {
        let parameters = ["id": id]
        send(url: path(""), parameters: parameters, complition: complition, error: error)
    }
    
    func logout(id: String, complition: @escaping (EmptyModel) -> (), error: @escaping (String) -> ()) {
        let parameters = ["id": id]
        send(url: path("logout"), parameters: parameters, complition: complition, error: error)
    }
    
    func getUser(id: String, complition: @escaping (UserExistModel) -> (), error: @escaping (String) -> ()) {
        let parameters = ["id": id]
        send(url: path("get"), parameters: parameters, complition: complition, error: error)
    }
    
    func delete(id: String, complition: @escaping (EmptyModel) -> (), error: @escaping (String) -> ()) {
        let parameters = ["id": id]
        send(url: path("delete"), parameters: parameters, complition: complition, error: error)
    }
    
    func upload(id: String?, email: String? = nil, phone: String? = nil, name: String? = nil, birthdate: String? = nil, gender: Int? = nil, rules: Bool? = nil, complition: @escaping (EmptyModel) -> (), error: @escaping (String) -> ()) {
        guard let id else { return error("no id") }
        
        var parameters: [String: Any] = ["id": id]
        
        if let email {
            parameters["email"] = email
        }
        if let phone {
            parameters["phone"] = phone
        }
        if let name {
            parameters["name"] = name
        }
        if let birthdate {
            parameters["birthdate"] = birthdate
        }
        if let gender {
            parameters["gender"] = gender
        }
        if let rules {
            parameters["rules"] = rules
        }
        
        guard parameters.count > 1 else { return }
        send(url: path("update"), parameters: parameters, complition: complition, error: error)
    }
}
