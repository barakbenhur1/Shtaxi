//
//  Authentication.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/08/2024.
//

import Foundation
import FirebaseAuth
import Firebase
import FacebookLogin
import GoogleSignIn

struct Authentication {
    private let queue = DispatchQueue.main
    
    private func checkStatus() -> GoogleAuthModel? {
        if GIDSignIn.sharedInstance.currentUser != nil {
            guard let user =  GIDSignIn.sharedInstance.currentUser else { return nil }
            guard let id = user.userID?.encrypt() else { return nil }
            var google = GoogleAuthModel(id: id)
            let givenName = user.profile?.givenName
            google.email = user.profile?.email ?? ""
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            google.givenName = givenName ?? ""
            google.profilePicUrl = profilePicUrl
            
            return google
        }
        return nil
    }
    
    func googleOauth(complition: @escaping (GoogleAuthModel?) -> ())  {
        // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else { return complition(nil) }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        queue.async {
            //get rootView
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = scene?.windows.first?.rootViewController
            else { fatalError("There is no root view controller!") }
            
            //google sign in authentication response
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                guard let user = result?.user else { return complition(nil) }
                guard let idToken = user.idToken?.tokenString else { return complition(nil) }
                
                //Firebase auth
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential)
                complition(checkStatus())
            }
        }
    }
    
    func facebookAuth(facebookAuthModel: @escaping (FacebookAuthModel) -> ()) {
        let fbLoginManager = LoginManager()
        
        //get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        fbLoginManager.logIn(permissions:  ["public_profile", "email"], from: rootViewController) { result, error in
            guard let tokenString = AccessToken.current?.tokenString else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else { return }
                guard let id = authResult?.user.uid.encrypt() else { return }
                facebookAuthModel(FacebookAuthModel(id: id,
                                                    birthday: "",
                                                    gender: "",
                                                    email: authResult?.user.email ?? ""))
            }
        }
    }
    
    func phoneAuth(phone: String, auth: @escaping (_ verificationID: String) -> (), error: @escaping (String?) -> ()) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phone.internationalPhone(), 
                               uiDelegate: nil) { verificationID, err in
                guard err == nil else { return error(err?.localizedDescription) }
                guard let verificationID else { return error("no verificationID") }
                auth(verificationID)
            }
    }
    
    func phoneVerify(verificationID: String, verificationCode: String, phoneAuthModel: @escaping (_ id: String, _ name: String, _ email: String) -> (), error: @escaping (String?) -> ()) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { result, err in
            guard err == nil else { return error("קוד שגוי") }
            guard let result else { return error("no result") }
            guard let id = result.user.uid.encrypt() else { return }
            phoneAuthModel(id, result.user.displayName ?? "", result.user.email ?? "")
        }
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
}


extension String: Error {}
