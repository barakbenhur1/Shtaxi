//
//  RouterView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import SwiftUI

struct RouterView<Content: View>: View {
    @EnvironmentObject private var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var router = Router.shared
    // Our root view content
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                        .environmentObject(manager)
                        .environment(\.managedObjectContext, manager.container.viewContext)
                }
        }
        .environmentObject(router)
    }
}
