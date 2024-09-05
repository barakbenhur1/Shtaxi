//
//  ProfileModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 31/08/2024.
//

import Foundation

struct ProfileModel: Codable {
    let id: String
    let email: String
    let phone: String
    let name: String
    let birthdate: String
    let gender: String
    let rules: Bool
    
    static let emptyUser = ProfileModel(id: "", email: "", phone: "", name: "", birthdate: "", gender: "", rules: false)
    static let userWithData = ProfileModel(id: "123456", email: "a@a.com", phone: "052-2126345", name: "a", birthdate: "11/11/1900", gender: "0", rules: true)
}
