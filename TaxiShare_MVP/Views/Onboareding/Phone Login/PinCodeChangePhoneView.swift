//
//  OnboardingChangePhoneView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI
import Combine

struct PinCodeChangePhoneView<VM: OnboardingViewModel>: ProfileUpdater {
    @State private var holder = Holder<LoginPhoneView>()
    
    @ObservedObject internal var vm: VM
   
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
                    .font(.textHugeBold)
                    .foregroundStyle(.black)
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
    
    func preformAction(manager: CoreDataManager, profile: Profile?, complete: @escaping (_ valid: Bool) -> ()) {
        guard let phone = holder.value?.text else {
            complete(false)
            return didDone(phone)
        }
        vm.phoneAuth(phone: phone) { id in
            verificationID = id
            complete(true)
            return didDone(phone)
        } error: { err in
            if let err { print(err) }
            complete(false)
            return didDone(phone)
        }
    }
}

//#Preview {
//    OnboardingChangePhoneView { _ in
//        
//    }
//}
