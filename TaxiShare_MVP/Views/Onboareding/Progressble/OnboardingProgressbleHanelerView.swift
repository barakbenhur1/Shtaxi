//
//  OnboardingProgressbleManegerView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

enum OnboardingProgressble: Codable, Hashable {
    case name(value: String), birthdate(value: String), gender(value: Int?), rules
}

struct OnboardingProgressbleHandelerView<Content: OnboardingProgress>: ProfileUpdater {
    @EnvironmentObject var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    internal let vm: OnboardringViewModel? = nil
    @Binding var value: Int
    let total: Int
    let content: Content?
    let onAppear: (any ProfileUpdater) -> ()
    
    var body: some View {
        if let content {
            OnboardingProgressbleView(value: $value,
                                      total: total,
                                      contant: content)
            .environmentObject(manager)
            .environment(\.managedObjectContext, viewContext)
            .onAppear { onAppear(self) }
        }
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        content?.preformAction(manager: manager,
                               profile: profile, 
                               complete: complete)
    }
}

//#Preview {
//    OnboardingProgressbleManegerView(value: .constant(0),
//                                      screens: [.rules, .birthdate, .gender, .rules]) { enable in
//
//    }
//}
