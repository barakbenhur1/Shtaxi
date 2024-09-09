//
//  CoreDataUseCases.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation
import CoreData

struct CoreDataUseCases: USeCase, CoreDataRepository {
    let repo: any CoreDataRepository
    
    var managedObjectContext: NSManagedObjectContext { return repo.managedObjectContext }
    
    func replace(profile: Profile, with id: String) -> Profile {
        return repo.replace(profile: profile, with: id)
    }
    
    func new(id: String) -> Profile {
        return repo.new(id: id)
    }
    
    func set(profile: Profile, logedin: Bool) {
        repo.set(profile: profile, logedin: logedin)
    }
    
    func set(profile: Profile, phone: String) {
        repo.set(profile: profile, phone: phone)
    }
    
    func set(profile: Profile, email: String) {
        repo.set(profile: profile, email: email)
    }
    
    func set(profile: Profile, name: String) {
        repo.set(profile: profile, name: name)
    }
    
    func set(profile: Profile, date: String) {
        repo.set(profile: profile, date: date)
    }
    
    func set(profile: Profile, gender: Int?) {
        repo.set(profile: profile, gender: gender)
    }
    
    func set(profile: Profile, rules: Bool) {
        repo.set(profile: profile, rules: rules)
    }
    
    func delete(profile: Profile) {
        repo.delete(profile: profile)
    }
    
    func save() {
        repo.save()
    }
}
