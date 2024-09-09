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
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding internal var value: Int
    internal let total: Int
    internal let content: Content?
    internal let onAppear: (any ProfileUpdater) -> ()
    
    var body: some View {
        if let content {
            OnboardingProgressbleView(value: $value,
                                      total: total,
                                      contant: content)
            .onAppear { onAppear(self) }
        }
    }
    
    func preformAction(profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        content?.preformAction(profile: profile,
                               complete: complete)
    }
}

//#Preview {
//    OnboardingProgressbleManegerView(value: .constant(0),
//                                      screens: [.rules, .birthdate, .gender, .rules]) { enable in
//
//    }
//}
