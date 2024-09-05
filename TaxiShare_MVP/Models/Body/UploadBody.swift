//
//  UploadBody.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/09/2024.
//

import Foundation

struct UploadBody: DictionaryRepresentable {
    var email: String? = nil
    var phone: String? = nil
    var name: String? = nil
    var birthdate: String? = nil
    var gender: Int? = nil
    var rules: Bool? = nil
}
