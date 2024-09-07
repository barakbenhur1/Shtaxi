//
//  OnboardingLoginView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct OnboardingLoginView<VM: OnboardringViewModel>: View {
    @ObservedObject internal var vm: VM
    internal let didSignup: (_ id: String, _ name: String?, _ email: String?, _ birthdate: String?, _ gender: String?) -> ()
    internal let didFillPhone: (_ number: String) -> ()
    private let main = DispatchQueue.main
    
    @ViewBuilder fileprivate var googleSignInButton: some View {
        let button = Button(action: {
            hideKeyboard()
            Task {
                vm.googleAuth { model in
                    guard let model else { return }
                    main.async {
                        didSignup(model.id,
                                  model.givenName,
                                  model.email, "",
                                  nil)
                    }
                }
            }
        }, label: {
            ZStack(alignment: .center) {
                Image("google")
                    .resizable()
                    .frame(width: 25,
                           height: 25)
                    .padding(.trailing, 195)
                
                Text("התחברות עם גוגל".localized())
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
        })
            .buttonStyle(LoginButtonStyle())
            .font(.title2.weight(.medium))
            .foregroundStyle(.black)
        
        makeLoginButton(view: button)
    }
    
    @ViewBuilder fileprivate var facebookSignInButton: some View {
        let button = Button(action: {
            hideKeyboard()
            vm.facebookAuth { model in
                main.async {
                    didSignup(model.id,
                              model.name,
                              model.email,
                              model.birthday,
                              model.gender)
                }
            }
        }, label: {
            ZStack(alignment: .center) {
                Image("facebook")
                    .resizable()
                    .frame(width: 25,
                           height: 25)
                    .padding(.trailing, 235)
                
                Text("התחברות עם פייסבוק".localized())
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
        })
            .buttonStyle(LoginButtonStyle())
            .font(.title2.weight(.medium))
            .foregroundStyle(.black)
        
        makeLoginButton(view: button)
    }
    
    @ViewBuilder fileprivate var appleSignInButton: some View {
        let button = SignInWithAppleButton(.signUp) { request in
            hideKeyboard()
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                main.async {
                    if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        guard let id = userCredential.user.encrypt() else { return }
                        didSignup(id,
                                  userCredential.fullName?.givenName,
                                  userCredential.email, "", nil)
                    }
                }
            case .failure:
                break
            }
        }
            .signInWithAppleButtonStyle(.white)
            .overlay(
                Capsule()
                    .stroke(Color.darkText ,
                            lineWidth: 1)
            )
        
        makeLoginButton(view: button)
    }
    
    var body: some View {
        VStack {
            TLogo(shape: Circle(),
                  size: 64)
            
            HStack {
                Spacer()
                RightText(text: "יצירת חשבון".localized(),
                          font: .title)
            }
            .padding(.bottom)
            
            VStack(spacing: 28) {
                facebookSignInButton
                appleSignInButton
                googleSignInButton
            }
            
            VStack {
                Spacer()
                orAndLines()
                LoginPhoneView(didType: didFillPhone)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    @ViewBuilder private func orAndLines() -> some View {
        HStack {
            line()
            or()
            line()
        }
        .padding(.top)
        .padding(.bottom)
    }
    
    @ViewBuilder private func or() -> some View {
        Text("או".localized())
            .frame(width: 52)
            .font(.textMedium)
            .foregroundStyle(Color.infoText)
    }
    
    @ViewBuilder private func line() -> some View {
        Image("line")
            .resizable()
            .frame(height: 1)
    }
    
    @ViewBuilder private func makeLoginButton(view: some View) -> some View {
        view
            .clipShape(Capsule())
            .frame(height: 56)
    }
}

private struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                configuration.isPressed ? .gray.opacity(0.8) :
                Color.clear
            }
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .overlay(
                Capsule()
                    .stroke(Color.darkText,
                            lineWidth: 1)
                    .allowsHitTesting(false)
            )
    }
}

//#Preview {
//    OnboardingLoginView() { _, _, _, _, _ in
//        
//    } didFillPhone: { _ in
//        
//    }
//}
