//
//  OnboardingRulesView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

struct OnboardingRulesView<VM: OnboardingViewModel>: OnboardingProgress {
    @ObservedObject internal var vm: VM
   
    internal let onAppear: (() -> ())?
    internal let noActionNeeded: (() -> ())? = nil
    internal let complition: ((_ enable: Bool) -> ())? = nil
    internal let otherAction: (() -> ())? = nil
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RightText(text: "ברוך הבא לשטקסי!",
                          font: .title)
            }
            HStack {
                Spacer()
                RightText(text: "כמה נקודות חשובות על האפליקציה שלנו",
                          font: .textMedium)
            }
            .padding(.bottom, 44)
            
            VStack {
                ruleView(title: "עקרון ראשון",
                         text: "Lorem ipsum dolor sit amet consectetur. Lorem turpis nullam.")
                .padding(.bottom, 20)
                
                ruleView(title: "עקרון שני",
                         text: "Lorem ipsum dolor sit amet consectetur. Lorem turpis nullam.")
                .padding(.bottom, 20)
                
                ruleView(title: "עקרון שלישי",
                         text: "Lorem ipsum dolor sit amet consectetur. Lorem turpis nullam.")
            }
        }
        .onAppear {
            onAppear?()
        }
    }
    
    @ViewBuilder private func ruleView(title: String, text: String) -> some View {
        VStack {
            HStack {
                Spacer()
                Image("bullet")
                    .resizable()
                    .frame(height: 28)
                    .frame(width: 28)
            }
            
            HStack {
                Spacer()
                RightText(text: title,
                          font: .textMediumBold)
                .foregroundStyle(Color.darkText)
            }
            
            HStack {
                Spacer()
                RightText(text: text,
                          font: .textMedium)
                .foregroundStyle(Color.infoText)
            }
        }
    }
    
    func preformAction(profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        guard let profile else { return complete(false) }
        vm.update(profile: profile,
                  updateBody: .init(rules: true)) {
            return complete(true)
        } error: { error in
            print(error)
            return complete(false)
        }
    }
}

//#Preview {
//    OnboardingRulesView {
//        
//    }
//}
