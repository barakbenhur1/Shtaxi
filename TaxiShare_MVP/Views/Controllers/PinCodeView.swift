//
//  PinCodeView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/08/2024.
//

import SwiftUI

struct PinCodeView: View, ProfileHandeler {
    @EnvironmentObject private var vmProvider: ViewModelProvider
    
    @State internal var buttonEnabled: Bool = false
    @State internal var externalActionLoading: Bool? = false
    @State private var changeNumber = false
    @State private var holder = Holder<any ProfileUpdater>()

    @State var phone: String
    @State var verificationID: String
    
    var body: some View {
        content()
            .wrapWithBottun(buttonText: "אישור".localized(),
                            preformAction: preformAction,
                            loadingForExternalActions: $externalActionLoading,
                            setButtonConfig: $buttonEnabled,
                            onTapGesture: { hideKeyboard() })
    }
    
    @ViewBuilder private func content() -> some View {
        if changeNumber { changePhone() }
        else { smsPinCodeView() }
    }
    
    @ViewBuilder private func smsPinCodeView() -> some View {
        SmsPinCodeView(vm: vmProvider.vm(),
                       phone: phone,
                       verificationID: verificationID,
                       onAppear: { view in holder.value = view },
                       didChnngeNumber: { changeNumber = true },
                       didDone: { isDone in buttonEnabled = isDone })
    }
    
    @ViewBuilder private func changePhone() -> some View {
        PinCodeChangePhoneView(vm: vmProvider.vm(),
                               phone: phone,
                               verificationID: $verificationID,
                               didType: { isDone in buttonEnabled = isDone },
                               onAppear: { view in holder.value = view },
                               didDone: change)
    }
    
    private func change(newPhone: String?) {
        if let newPhone { phone = newPhone }
        changeNumber = false
    }
    
    func preformAction(complete: @escaping (Bool) -> ()) {
        holder.value?.preformAction(profile: nil,
                                    complete: complete)
    }
}

//
//#Preview {
//    PinCodeView(phone: "",
//                verificationID: "",
//                buttonConfig: .constant(.defulat(state: .disabled, dimantions: .full))) { _ in
//
//    } didApprove: { _, _, _ in
//
//    }
//}
