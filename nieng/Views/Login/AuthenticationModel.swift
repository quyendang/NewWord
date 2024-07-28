//
//  AuthenticationModel.swift
//  nieng
//
//  Created by Quyen Dang on 17/07/2023.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import UserNotifications

enum LoginType {
    case email
    case apple
    case google
}

final class AuthenticationModel: NSObject, ObservableObject {
    @Published var isAuthenticating = false
    @Published var error: NSError?
    private let auth = Auth.auth()
    fileprivate var currentNonce: String?
    @Published var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Database.database()
            .reference()
            .child("users/\(uid)")
        return ref
    }()
    
    override init() {
        self.user = auth.currentUser
    }
    
    func listenToAuthState() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
        }
    }
    
    func removeData(){
        guard let databasePath = databasePath else {
            return
        }
        
        databasePath.removeValue()
    }
    

    
    func login(_ type: LoginType) {
        self.isAuthenticating = true
        self.error = nil
        if type == .apple {
            handleSignInWithApple()
        }
        if type == .google {
            handleSignInWithGoogle()
        }
    }
    
    
    private func handleAuthResultCompletion(auth: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async { [self] in
            self.isAuthenticating = false
            if let user = auth?.user {
                guard let databasePath = databasePath else {
                    return
                }
                databasePath.observeSingleEvent(of: .value) { snapshot in
                    self.user = user
                }
                
            } else if let error = error {
                self.error = error as NSError
            }
        }
    }
    
    func signout() {
        try? auth.signOut()
    }
    
    func signIn(email: String?, password: String?, completion: @escaping (Error?) -> Void) {
        self.isAuthenticating = true
        guard let email = email, let password = password else {
            completion(nil)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    func signUp(email: String?, password: String?, completion: @escaping (Error?) -> Void) {
        guard let email = email, let password = password else {
            completion(nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
}


extension AuthenticationModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    private func handleSignInWithApple() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func handleSignInWithGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else{
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                guard let result = result else {
                    print("Unable to login with Google")
                    return
                }
                authenticateUser(for: result.user, with: error)
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows[0]
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
        self.isAuthenticating = false
        self.error = error as NSError
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let accessToken = user?.accessToken, let idToken = user?.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
    }
}
