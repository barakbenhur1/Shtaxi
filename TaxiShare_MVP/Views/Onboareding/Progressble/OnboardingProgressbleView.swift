//
//  OnboardingProgressbleView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct OnboardingProgressbleView<Contant: OnboardingProgress>: View {
    @EnvironmentObject private var manager: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding internal var value: Int
    @State internal var texts: [String]
    internal let total: Int
    internal let contant: Contant
    
    init(value: Binding<Int>, total: Int, contant: Contant) {
        _value = value
        self.total = total
        self.contant = contant
        
        let prepareTexts = {
            var texts = [String]()
            for i in 0..<total {
                if i == total - 2 { texts.append("כבר מסיימים..") }
                else if i == 0 { texts.append("כמה פרטים וסיימנו..") }
                else if i == total - 1 { texts.append("אחרון להיום..") }
                else { texts.append("עוד רגע שם..") }
            }
            return texts
        }
        
        self.texts = prepareTexts()
    }
    
    var body: some View {
        VStack() {
            TProgressBar(text: texts[value],
                         total: total,
                         value: $value)
            .padding(.bottom, 50)
            contant
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
            Spacer()
        }
    }
}

//#Preview {
//    OnboardingProgressbleView(value: .constant(0),
//                               total: 4,
//                               contant: OnboardingNameView() { _ in
//        
//    })
//}
