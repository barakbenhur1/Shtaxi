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
    @StateObject private var vmProvider = ViewModelProvider.shared
    @StateObject private var profileSync = ProfileSyncHendeler.shared
    
    @State private var showError = false
    
    private let local = Locale(identifier: "he-IL")
    private let apiError = NotificationCenter.default.publisher(for: .apiError)
    private let popToLogin = NotificationCenter.default.publisher(for: .popToLogin)
    
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
            .onOpenURL { url in DispatchQueue.main.async { _ = Auth.auth().canHandle(url) } }
            .onReceive(apiError) { _ in showError = true }
            .onReceive(popToLogin) { value in router.popToRoot(message: value.object as? LoginError,
                                                               animate: true) }
            .customAlert("הפעולה נכשלה",
                         type: .info,
                         isPresented: $showError,
                         actionText: "הבנתי") {
                Text("אנא נסה שנית...".localized())
            }
        }
    }
}
