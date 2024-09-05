//
//  Persistence.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 27/06/2024.
//

import CoreData

class PersistenceController: NSObject, ObservableObject {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaxiShare_MVP")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func replace(profile: Profile, with id: String) -> Profile {
        delete(profile: profile)
        return new(id: id)
    }
    
    @discardableResult func new(id: String) -> Profile {
        let profile = Profile(context: container.viewContext)
        profile.userID = id
        save()
        return profile
    }
    
    func set(profile: Profile, phone: String) {
        profile.phone = phone
        save()
    }
    
    func set(profile: Profile, email: String) {
        profile.email = email
        save()
    }
    
    func set(profile: Profile, name: String) {
        profile.name = name
        save()
    }
    
    func set(profile: Profile, date: String) {
        profile.age = date
        save()
    }
    
    func set(profile: Profile, gender: Int?) {
        profile.gender = gender != nil ? "\(gender!)" : ""
        save()
    }
    
    func set(profile: Profile, rules: Bool) {
        profile.rules = rules
        save()
    }
    
    
    func delete(profile: Profile) {
        container.viewContext.delete(profile)
        save()
    }
    
    func save() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print(error)
        }
    }
}
