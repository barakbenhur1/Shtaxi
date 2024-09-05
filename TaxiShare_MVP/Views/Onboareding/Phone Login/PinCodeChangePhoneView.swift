//
//  OnboardingChangePhoneView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI
import Combine

struct PinCodeChangePhoneView: ProfileUpdater {
    internal let vm = OnboardringViewModel()
   
    @State private var holder = Holder<LoginPhoneView>()
    
    @State var phone: String
    @Binding var verificationID: String
    let didType: (_ enable: Bool) -> ()
    let onAppear: (any ProfileUpdater) -> ()
    let didDone: (_ phone: String?) -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                didDone(nil)
            } label: {
                Text("⇐")
                    .font(Custom.shared.font.textHugeBold)
                    .foregroundStyle(Custom.shared.color.black)
            }
            
            LoginPhoneView(text: phone,
                           beginFocused: true,
                           didType: valid,
                           onAppear: { view in holder.value = view })
            .padding(.top, 118)
        }
        
        .onAppear { onAppear(self) }
    }
    
    private func valid(phone: String) {
        didType(phone.count == 11)
    }
    
    func preformAction(manager: PersistenceController, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        guard let phone = holder.value?.text else {
            complete(false)
            return didDone(phone)
        }
        vm.phoneAuth(phone: phone) { id in
            verificationID = id
            complete(true)
            didDone(phone)
        } error: { err in
            complete(false)
            didDone(phone)
            guard let err else { return }
            print(err)
        }
    }
}

//#Preview {
//    OnboardingChangePhoneView { _ in
//        
//    }
//}
