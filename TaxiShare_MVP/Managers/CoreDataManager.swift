//
//  CoreDataManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation
import CoreData

class CoreDataManager: ViewModel {
    static let shared = CoreDataManager()
    
    internal let useCases = CoreDataUseCases(repo: CoreDataRepositoryImpl(dataSource: PersistenceController.shared))
    
    var managedObjectContext: NSManagedObjectContext { return useCases.managedObjectContext }
    
    required internal init() {}
    
    func replace(profile: Profile, with id: String) -> Profile {
        return useCases.replace(profile: profile, with: id)
    }
    
    func new(id: String) -> Profile {
        return useCases.new(id: id)
    }
    
    func set(profile: Profile, logedin: Bool) {
        useCases.set(profile: profile, logedin: logedin)
    }
    
    func set(profile: Profile, phone: String) {
        useCases.set(profile: profile, phone: phone)
    }
    
    func set(profile: Profile, email: String) {
        useCases.set(profile: profile, email: email)
    }
    
    func set(profile: Profile, name: String) {
        useCases.set(profile: profile, name: name)
    }
    
    func set(profile: Profile, date: String) {
        useCases.set(profile: profile, date: date)
    }
    
    func set(profile: Profile, gender: Int?) {
        useCases.set(profile: profile, gender: gender)
    }
    
    func set(profile: Profile, rules: Bool) {
        useCases.set(profile: profile, rules: rules)
    }
    
    func delete(profile: Profile) {
        useCases.delete(profile: profile)
    }
    
    func save() {
        useCases.save()
    }
}
