//
//  CoreDataRepositoryImpl.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation
import CoreData

struct CoreDataRepositoryImpl: CoreDataRepository {
    let dataSource: CoreDataRepository
   
    var managedObjectContext: NSManagedObjectContext { return dataSource.managedObjectContext }
    
    func replace(profile: Profile, with id: String) -> Profile {
        return dataSource.replace(profile: profile, with: id)
    }
    
    func new(id: String) -> Profile {
        return dataSource.new(id: id)
    }
    
    func set(profile: Profile, logedin: Bool) {
        dataSource.set(profile: profile, logedin: logedin)
    }
    
    func set(profile: Profile, phone: String) {
        dataSource.set(profile: profile, phone: phone)
    }
    
    func set(profile: Profile, email: String) {
        dataSource.set(profile: profile, email: email)
    }
    
    func set(profile: Profile, name: String) {
        dataSource.set(profile: profile, name: name)
    }
    
    func set(profile: Profile, date: String) {
        dataSource.set(profile: profile, date: date)
    }
    
    func set(profile: Profile, gender: Int?) {
        dataSource.set(profile: profile, gender: gender)
    }
    
    func set(profile: Profile, rules: Bool) {
        dataSource.set(profile: profile, rules: rules)
    }
    
    func delete(profile: Profile) {
        dataSource.delete(profile: profile)
    }
    
    func save() {
        dataSource.save()
    }
}
