//
//  String+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import Foundation

extension String {
    mutating func replace(at i: Int, with c: Character) {
        let index = index(startIndex, offsetBy: i)
        remove(at: index)
        insert(c, at: index)
    }
    
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
    
    func asClassName() -> String {
        return replacingOccurrences(of: "TaxiShare_MVP.", with: "")
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
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
