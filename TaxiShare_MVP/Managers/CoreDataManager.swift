//
//  CoreDataManager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation
import CoreData

class CoreDataManager: Singleton, CoreDataRepository {
    private let coreData: CoreDataHndeler = ViewModelProvider.shared.viewModel()
    
    private override init() {}
    
    var managedObjectContext: NSManagedObjectContext { return coreData.managedObjectContext }
    
    func replace(profile: Profile, with id: String) -> Profile {
        return coreData.replace(profile: profile, with: id)
    }
    
    func new(id: String) -> Profile {
        return coreData.new(id: id)
    }
    
    func set(profile: Profile, logedin: Bool) {
        coreData.set(profile: profile, logedin: logedin)
    }
    
    func set(profile: Profile, phone: String) {
        coreData.set(profile: profile, phone: phone)
    }
    
    func set(profile: Profile, email: String) {
        coreData.set(profile: profile, email: email)
    }
    
    func set(profile: Profile, name: String) {
        coreData.set(profile: profile, name: name)
    }
    
    func set(profile: Profile, date: String) {
        coreData.set(profile: profile, date: date)
    }
    
    func set(profile: Profile, gender: Int?) {
        coreData.set(profile: profile, gender: gender)
    }
    
    func set(profile: Profile, rules: Bool) {
        coreData.set(profile: profile, rules: rules)
    }
    
    func delete(profile: Profile) {
        coreData.delete(profile: profile)
    }
    
    func save() {
        coreData.save()
    }
}
