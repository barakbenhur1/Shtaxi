//
//  UploadBody.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/09/2024.
//

import Foundation

enum UpdateBodyType {
    case email, phone, name, birthdate, gender, rules
}

struct UpdateBody: DictionaryRepresentable {
    var email: String? = nil
    var phone: String? = nil
    var name: String? = nil
    var birthdate: String? = nil
    var gender: Int? = nil
    var rules: Bool? = nil
    
    func getValue() -> (key: UpdateBodyType, value: Any)? {
        if email != nil { return (.email, email as Any) }
        if phone != nil { return (.phone, phone as Any) }
        if name != nil { return (.name, name as Any) }
        if birthdate != nil { return (.birthdate, birthdate as Any) }
        if gender != nil { return (.gender, gender as Any) }
        if rules != nil { return (.rules, rules as Any) }
        
        return nil
    }
}
