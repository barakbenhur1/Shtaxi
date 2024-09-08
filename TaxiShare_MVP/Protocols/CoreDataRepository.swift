//
//  CoreDataRepository.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation
import CoreData

protocol CoreDataRepository {
    var managedObjectContext: NSManagedObjectContext { get }
    func replace(profile: Profile, with id: String) -> Profile
    @discardableResult func new(id: String) -> Profile
    func set(profile: Profile, logedin: Bool)
    func set(profile: Profile, phone: String)
    func set(profile: Profile, email: String)
    func set(profile: Profile, name: String)
    func set(profile: Profile, date: String)
    func set(profile: Profile, gender: Int?)
    func set(profile: Profile, rules: Bool)
    func delete(profile: Profile)
    func save()
}
