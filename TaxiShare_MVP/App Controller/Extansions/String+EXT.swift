//
//  String+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation

extension String {
    mutating func limitText(_ upper: Int) {
        if count > upper {
            self = String(prefix(upper))
        }
    }
    
    mutating func formatPhone() {
        if count == 4 {
            if last == "-" {
                _ = popLast()
            }
            else {
                guard let last = popLast() else { return }
                self = "\(self)-\(last)"
            }
        }
        else if count > 4 {
            self = replacingOccurrences(of: "-", with: "")
            let prefix = prefix(3)
            let suffix = suffix(count - 3)
            self = "\(prefix)-\(suffix)"
        }
    }
    
    
    /* Change to be #else statement if not testing */
    func internationalPhone() -> String {
#if DEBUG
        return "+1\(replacingOccurrences(of: "-", with: "").suffix(count - 1))"
#else
        return "+972\(replacingOccurrences(of: "-", with: "").suffix(count - 2))"
#endif
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{7}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func encrypt() -> String? {
        do {
            let inputData = Data(utf8)
            let hashed = try CryptoManager.encryptData(data: inputData)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //    func decrypt() -> String? {
    //        do {
    //            guard let outputData = data(using: .utf8) else { throw "data corrupted" }
    //            let decryptedData = try CryptoManager.decryptData(data: outputData)
    //            return String(data: decryptedData, encoding: .utf8)
    //        } catch {
    //            print(error.localizedDescription)
    //            return nil
    //        }
    //    }
}
