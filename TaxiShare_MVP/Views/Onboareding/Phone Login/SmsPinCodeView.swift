//
//  SmsPinCodeView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 03/08/2024.
//

import SwiftUI

struct SmsPinCodeView<VM: OnboardringViewModel>: ProfileUpdater {
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
    
    @ObservedObject internal var vm: VM
    let phone: String
    @State var verificationID: String
    let onAppear: (SmsPinCodeView) -> ()
    let didChnngeNumber: () -> ()
    let didDone: (Bool) -> ()
    
    @State private var holder = Holder<String>()
    @State private var error: Bool = false
    @State private var errorValue: String? = nil {
        didSet {
            if let errorValue { error = !errorValue.isEmpty }
            else { error = false }
        }
    }
    
    var body: some View {
        VStack {
            TLogo(shape: Circle(), 
                  size: 64)
                .padding(.bottom, 40)
            
            HStack {
                Spacer()
                RightText(text: "הכנסת קוד",
                          font: .title)
            }
            .padding(.bottom, 4)
            
            HStack(spacing: 0) {
                Button(action: {
                    didChnngeNumber()
                }, label: {
                    Text("טעות במספר?".localized())
                        .font(.button)
                })
                
                Spacer()
                RightText(text: phone,
                          font: .textMediumBold)
                
                RightText(text: "שלחנו קוד ל ",
                          font: .textMedium)
            }
            
            VStack {
                TPinCodeView(error: $error) { pinArray in
                    let pinCode = pinArray.joined()
                    if pinCode != holder.value { errorValue = nil }
                    holder.value = pinCode
                    didDone(!pinArray.contains(""))
                }
                
                if let errorValue {
                    Text(errorValue)
                        .foregroundStyle(.red)
                        .font(.textSmall)
                        .padding(.bottom, -5)
                }
            }
            .padding(.bottom, 20)
            
            Text("Lorem ipsum dolor sit amet consectetur. Pulvinar sed in dui auctor imperdiet posuere bibendum. Diam sit sed semper.")
                .multilineTextAlignment(.center)
                .font(.textSmall)
                .foregroundStyle(Color.infoText)
                .padding(.bottom, 4)
            
            Button(action: {
                errorValue = nil
                vm.phoneAuth(phone: phone) { id in
                    verificationID = id
                } error: { err in
                    errorValue = nil
                    guard let err else { return }
                    print(err)
                }
            }, label: {
                Text("שליחה חוזרת")
                    .font(.textMedium)
                    .foregroundStyle(Color.tBlue)
                    .frame(height: 26)
            })
        }
        .onAppear {
            onAppear(self)
        }
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        errorValue = nil
        guard let pinCode = holder.value else { return }
        do {
            vm.verifayPinCode(verificationID: verificationID,
                              code: pinCode) { model in
                profileSync.handleLoginTap(profile: profile,
                                           id: model.id,
                                           email: model.email,
                                           phone: phone,
                                           name: model.name,
                                           birthdate: "",
                                           gender: "",
                                           didLogin: complete)
            } error: { err in
                if let err { print(err) }
                errorValue = err
                return complete(false)
            }
        }
    }
}

//#Preview {
//    SmsPinCodeView(phone: "050-2217124",
//                   verificationID: "") {
//
//    } didDone: { _ in
//
//    } didApprove: { _, _ in
//
//    }
//}
