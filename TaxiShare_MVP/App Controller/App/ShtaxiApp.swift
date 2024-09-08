//
//  TaxiShare_MVPApp.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 27/06/2024.
//

import SwiftUI
import GoogleSignIn
import FacebookCore
import FirebaseFirestore
import Firebase
import FirebaseAuth

@main
struct ShtaxiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var manager = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            RouterView() {
                RootView()
            }
            .onOpenURL { url in
                DispatchQueue.main.async {
                    _ = Auth.auth().canHandle(url)
                    GIDSignIn.sharedInstance.handle(url)
                    ApplicationDelegate.shared.application(UIApplication.shared,
                                                           open: url,sourceApplication: nil,
                                                           annotation: UIApplication.OpenURLOptionsKey.annotation)
                }
            }
            .environmentObject(manager)
            .environment(\.managedObjectContext, manager.managedObjectContext)
        }
    }
}
