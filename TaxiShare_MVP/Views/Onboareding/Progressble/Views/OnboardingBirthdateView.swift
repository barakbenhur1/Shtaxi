//
//  OnboardingBirthdateView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

struct OnboardingBirthdateView<VM: OnboardringViewModel>: OnboardingProgress {    
    @State private var holder = Holder<String>()
    
    @ObservedObject internal var vm: VM
    
    @State private var error: Bool = false
    @State private var errorValue: String = "" { didSet { error = !errorValue.isEmpty } }
   
    @State var date: String { didSet { holder.value = date } }
    
    internal let onAppear: (() -> ())? = nil
    internal let noActionNeeded: (() -> ())? = nil
    internal let complition: ((_ enable: Bool) -> ())?
    internal let otherAction: (() -> ())? = nil
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RightText(text: "מה תאריך הלידה שלך?",
                          font: .title)
            }
            .padding(.bottom, 20)
            
            VStack {
                let componnets = date.components(separatedBy: "/")
                let (day, month, year) = componnets.count == 3 ? (componnets[0], componnets[1], componnets[2]) : ("", "", "")
                TDateTextFiled(day: day,
                               month: month,
                               year: year,
                               error: $error) { day, month, year in
                    let newDate = "\(day)/\(month)/\(year)"
                    if newDate != date { errorValue = "" }
                    date = newDate
                    let dayValid = day.count == 2
                    let monthValid = month.count == 2
                    let yearValid = year.count == 4
                    complition?(dayValid && monthValid && yearValid)
                }
                
                if !errorValue.isEmpty {
                    Text(errorValue)
                        .foregroundStyle(.red)
                        .font(.textSmall)
                        .padding(.bottom, -5)
                }
            }
            .padding(.bottom, 20)
            
            Text("כדי להתאים את הנסיעות הנכונות עבורך אנחנו צריכים להבין מה תאריך הלידה שלך. בפרופיל נציג את הגיל שלך.")
                .multilineTextAlignment(.center)
                .font(.textSmall)
                .foregroundStyle(Color.infoText)
        }
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        errorValue = ""
        guard let profile else { return complete(false) }
        guard let birthdate = holder.value else { return complete(false) }
        vm.update(profile: profile,
                  updateBody: .init(birthdate: birthdate)) {
            manager.set(profile: profile,
                        date: birthdate)
            return complete(true)
        } error: { error in
            print(error)
            return complete(false)
        }
    }
}

//#Preview {
//    OnboardingBirthdateView { _ in
//
//    }
//}
