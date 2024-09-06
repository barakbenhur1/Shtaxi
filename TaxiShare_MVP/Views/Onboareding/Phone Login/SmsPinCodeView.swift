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
    let didApprove: (_ id: String, _ name: String, _ email: String, _ didLogin: @escaping (_ uploadSuccess: @escaping ([OnboardingProgressble]) -> (), _ onFail: @escaping () -> ()) -> ()) -> ()
    
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
                          font: Custom.shared.font.title)
            }
            .padding(.bottom, 4)
            
            HStack(spacing: 0) {
                Button(action: {
                    didChnngeNumber()
                }, label: {
                    Text("טעות במספר?".localized())
                        .font(Custom.shared.font.button)
                })
                
                Spacer()
                RightText(text: phone,
                          font: Custom.shared.font.textMediumBold)
                
                RightText(text: "שלחנו קוד ל ",
                          font: Custom.shared.font.textMedium)
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
                        .foregroundStyle(Custom.shared.color.red)
                        .font(Custom.shared.font.textSmall)
                        .padding(.bottom, -5)
                }
            }
            .padding(.bottom, 20)
            
            Text("Lorem ipsum dolor sit amet consectetur. Pulvinar sed in dui auctor imperdiet posuere bibendum. Diam sit sed semper.")
                .multilineTextAlignment(.center)
                .font(Custom.shared.font.textSmall)
                .foregroundStyle(Custom.shared.color.infoText)
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
                    .font(Custom.shared.font.textMedium)
                    .foregroundStyle(Custom.shared.color.tBlue)
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
                              code: pinCode) { id, name, email in
                vm.login(id: id) { user in
                    let profile = manager.new(id: user.id)
                    didApprove(id, name, email) { uploadSuccess, onFail in
                        vm.update(profile: profile,
                                  updateBody: .init(phone: phone)) {
                            manager.set(profile: profile,
                                        phone: phone)
                            
                            let screens = profileSync.onboardingScreens(user: user,
                                                                                       syncedProfile: profile,
                                                                                       email: email,
                                                                                       name: name,
                                                                                       birthdate: "",
                                                                                       gender: "")
                            
                            uploadSuccess(screens)
                            complete(true)
                        } error: { err in
                            print(err)
                            onFail()
                            complete(false)
                        }
                    }
                } error: { error in
                    print(error)
                    complete(false)
                }
            } error: { err in
                if let err { print(err) }
                errorValue = err
                complete(false)
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
