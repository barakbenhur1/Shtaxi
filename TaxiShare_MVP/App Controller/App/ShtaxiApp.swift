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
    typealias UrlHandler = (URL) -> ()
    typealias PublisherOutput = (NotificationCenter.Publisher.Output) -> ()
    
    @UIApplicationDelegateAdaptor private var delegate: AppDelegate
    
    @StateObject private var router = Router.shared
    @StateObject private var manager = CoreDataManager.shared
    @StateObject private var vmProvider = ViewModelProvider.shared
    @StateObject private var profileSync = ProfileSyncHendeler.shared
    @StateObject private var launchScreenManager = LaunchScreenStateManager.shared
    
    @State private var showError = false
    
    private let local = Locale(identifier: "he-IL")
    private let apiError = NotificationCenter.default.publisher(for: .apiError)
    private let popToLogin = NotificationCenter.default.publisher(for: .popToLogin)
    
    private var canHandle: UrlHandler { return { url in _ = Auth.auth().canHandle(url) } }
    private var onEror: PublisherOutput { return { _ in showError = true } }
    private var onFualire: PublisherOutput { return { value in router.popToRoot(message: value.object as? LoginError,
                                                                                animate: true) } }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RouterView() { RootView() }
                    .environmentObject(router)
                    .environmentObject(manager)
                    .environmentObject(vmProvider)
                    .environmentObject(profileSync)
                    .environment(\.locale, local)
                    .environment(\.managedObjectContext,
                                  manager.managedObjectContext)
                    .onOpenURL(perform: canHandle)
                    .onReceive(popToLogin,
                               perform: onFualire)
                    .onReceive(apiError,
                               perform: onEror)
                    .customAlert("שגיאה!",
                                 type: .info,
                                 isPresented: $showError,
                                 actionText: "הבנתי",
                                 message: { Text("אנא נסה שנית...".localized()) })
                
                if launchScreenManager.state != .finished { LaunchScreenView() }
            }
            .environmentObject(launchScreenManager)
        }
    }
}
