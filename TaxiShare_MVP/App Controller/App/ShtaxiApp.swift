//
//  TaxiShare_MVPApp.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 27/06/2024.
//

import SwiftUI
import FirebaseAuth

@main
struct ShtaxiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var router = Router.shared
    @StateObject private var manager = CoreDataManager.shared
    @StateObject private var profileSync = ProfileSyncHendeler.shared
    @StateObject private var vmProvider = ViewModelProvider.shared
    
    private let popToLogin = NotificationCenter.default.publisher(for: .popToLogin)
   
    private var local = Locale(identifier: "he-IL")
    
    var body: some Scene {
        WindowGroup {
            RouterView() {
                RootView()
            }
            .environmentObject(router)
            .environmentObject(profileSync)
            .environmentObject(manager)
            .environmentObject(vmProvider)
            .environment(\.locale, local)
            .environment(\.managedObjectContext, manager.managedObjectContext)
            .onReceive(popToLogin) { value in router.popToRoot(message: value.object as? LoginError ) }
            .onOpenURL { url in DispatchQueue.main.async { _ = Auth.auth().canHandle(url) } }
        }
    }
}
